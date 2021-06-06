---
title: Installing Arch Linux
date: 2021-02-12T00:00:00
---

This note includes all commands I typed when I set up Arch Linux on my new bare metal server.

# Why I choose Arch Linux

- Simple as it should be
- Outstanding community efforts to maintaining package registry
- Well organized wiki resources

# Setup

## wipe whole disk

```bash
wipefs -a /dev/sda
```

## create partition

```bash
parted

select /dev/sda
mktable gpt
mkpart EFI fat32 0 512MB # EFI
mkpart Arch ext4 512MB 100% # Arch
set 1 esp on # flag part1 as ESP
quit
```

## install file-system

```bash
mkfs.vfat -F 32 /dev/sda1 # EFI
mkfs.ext4 /dev/sda2 # Arch
```

## mount disk

```bash
mkdir -p /mnt/boot
mount /dev/sda2 /mnt
mount /dev/sda1 /mnt/boot
```

## install base & Linux kernel

```bash
reflector -f 10 --latest 30 --protocol https --sort rate --save /etc/pacman.d/mirrorlist # optimize mirror list

# choose between 'linux' or 'linux-lts'
pacstrap /mnt base linux linux-firmware
# base-devel need to be included as well?
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

```bash
pacman -Syu # upgrade
pacman -Qe # list explicitly installed pkgs
pacman -Rs # remove pkg and its deps
pacman -Qtd # list orphans

pacman -S man-db man-pages git informant
```

## bootloader

```bash
pacman -S \
  grub \
  efibootmgr \
  amd-ucode # AMD microcode
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

vim /etc/default/grub
# GRUB_TIMEOUT=3
# GRUB_DISABLE_SUBMENU=y
grub-mkconfig -o /boot/grub/grub.cfg
```

- [GRUB/Tips and tricks - ArchWiki](https://wiki.archlinux.org/title/GRUB/Tips_and_tricks)

## NTP

```bash
sed -i -e 's/#NTP=/NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org/' -e 's/#Fall/Fall/' /etc/systemd/timesyncd.conf
systemctl enable --now systemd-timesyncd
```

## locale

```bash
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc
vim /etc/locale.gen & locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

## network

```bash
hostnamectl set-hostname polka
hostnamectl set-chassis server
```

```ini /etc/hosts
127.0.0.1 localhost
::1       localhost
127.0.0.1 polka
```

See https://systemd.network/systemd.network.html.

```ini /etc/systemd/network/wired.network
[Match]
Name=enp5s0

[Network]
#DHCP=yes
Address=10.0.1.2/24
Gateway=10.0.1.1
DNS=10.0.1.100   # self-hosted DNS resolver
DNS=1.1.1.1      # Cloudflare for the fallback DNS server
MACVLAN=dns-shim # to handle local dns lookup to 10.0.1.100 which is managed by Docker macvlan driver
```

```ini /etc/systemd/network/dns-shim.netdev
# to handle local dns lookup to 10.0.1.100
[NetDev]
Name=dns-shim
Kind=macvlan

[MACVLAN]
Mode=bridge
```

```ini /etc/systemd/network/dns-shim.network
# to handle local dns lookup to 10.0.1.100
[Match]
Name=dns-shim

[Network]
IPForward=yes

[Address]
Address=10.0.1.103/32
Scope=link

[Route]
Destination=10.0.1.100/30
```

`ip` equivalent to the above settings:

```bash
ip link add dns-shim link enp5s0 type macvlan mode bridge # add macvlan shim
ip a add 10.0.1.103/32 dev dns-shim # assign host ip to shim defined in docker-compose.yml
ip link set dns-shim up # enable interface
ip route add 10.0.1.100/30 dev dns-shim # route macvlan subnet to shim interface
```

```bash
systemctl enable --now systemd-networkd
networkctl status

# for self-hosted dns resolver
sed -r -i -e 's/#?DNSStubListener=yes/DNSStubListener=no/g' -e 's/#DNS=/DNS=10.0.1.100/g' /etc/systemd/resolved.conf
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

systemctl enable --now systemd-resolved
resolvectl status
resolvectl query ddg.gg
drill @10.0.1.100 ddg.gg

# FIXME
pacman -S wpa_supplicant
vim /etc/wpa_supplicant/wpa_supplicant.conf
# ctrl_interface=/run/wpa_supplicant
# update_config=1
wpa_supplicant -B -i wlp8s0 -c /etc/wpa_supplicant/wpa_supplicant.conf
wpa_cli # default control socket -> /var/run/wpa_supplicant
modinfo iwlwifi
```

If `networkctl` keep showing `enp5s0` as `degraded`, then run `ip addr add 10.0.1.2/24 dev enp5s0 ` to manually assign static IP address for the workaround.

## firewall

```bash
pacman -S firewalld
# TODO
```

See also [Introduction to Netfilter – To Linux and beyond !](https://home.regit.org/netfilter-en/netfilter/)

## shell

```bash
pacman -S zsh
chsh -s /bin/zsh
```

## user

```bash
passwd # change root passwd

useradd -m -s /bin/zsh uetchy # add local user
passwd uetchy # change local user password

userdbctl # verify users

pacman -S sudo
echo "%sudo ALL=(ALL) NOPASSWD:/usr/bin/pacman" > /etc/sudoers.d/pacman # allow users in sudo group to run pacman without password (optional)
usermod -aG sudo uetchy # add local user to sudo group
visudo -c
```

## ssh

```bash
pacman -S openssh
vim /etc/ssh/sshd_config
systemctl enable --now sshd
```

on the host machine:

```bash
ssh-copy-id uetchy@10.0.1.2
```

## AUR

```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## finalize

```bash
exit # leave chroot
umount -R /mnt
reboot
```

# Additional setup

## nvidia

```bash
pacman -S nvidia # 'nvidia-lts' for linux-lts
cat /var/lib/modprobe.d/nvidia.conf # ensure having 'blacklist nouveau'

nvidia-smi # test runtime
```

## docker

https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/arch-overview.html

```bash
pacman -S docker docker-compose
yay -S nvidia-container-runtime
```

```json /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m", // default: -1 (unlimited)
    "max-file": "3" // default: 1
  },
  "exec-opts": ["native.cgroupdriver=systemd"], // for kubernetes
  "runtimes": {
    // for docker-compose
    "nvidia": {
      "path": "/usr/bin/nvidia-container-runtime",
      "runtimeArgs": []
    }
  }
}
```

```bash
systemctl enable --now docker

groupadd docker
usermod -aG docker user

GPU_OPTS=(--gpus all --device /dev/nvidia0 --device /dev/nvidiactl --device /dev/nvidia-modeset --device /dev/nvidia-uvm --device /dev/nvidia-uvm-tools)
docker run --rm -it ${GPU_OPTS} nvidia/cuda:10.2-cudnn7-runtime nvidia-smi
docker run --rm -it ${GPU_OPTS} tensorflow/tensorflow:1.14.0-gpu-py3 bash
```

### Use `journald` log driver in Docker Compose

```yaml
services:
  web:
    logging:
      driver: "journald"
      options:
        tag: "{{.ImageName}}/{{.Name}}/{{.ID}}" # default: "{{.ID}}"
```

- [Configure logging drivers | Docker Documentation](https://docs.docker.com/config/containers/logging/configure/)

## Telegraf

```bash
yay -S telegraf
vim /etc/telegraf/telegraf.conf
```

```ini /etc/sudoers.d/telegraf
Cmnd_Alias FAIL2BAN = /usr/bin/fail2ban-client status, /usr/bin/fail2ban-client status *
telegraf  ALL=(root) NOEXEC: NOPASSWD: FAIL2BAN
Defaults!FAIL2BAN !logfile, !syslog, !pam_session
```

```bash
chmod 440 /etc/sudoers.d/telegraf
```

## fail2ban

```
pacman -S fail2ban
systemctl enable --now fail2ban
```

```ini /etc/fail2ban/jail.local
[DEFAULT]
bantime = 60m
ignoreip = 127.0.0.1/8 10.0.1.0/24

[sshd]
enabled = true
port = 22,10122

[mailu]
enabled = true
backend = systemd
journalmatch = CONTAINER_NAME=mailu_front_1
port = smtp,submission
chain = DOCKER-USER
filter = mailu
findtime = 600
maxretry = 1
bantime = 1d
```

```ini /etc/fail2ban/filter.d/mailu.conf
[INCLUDES]
before = common.conf

[Definition]
failregex = ^%(__prefix_line)s\d+\/\d+\/\d+ \d+:\d+:\d+ \[info\] \d+#\d+: \*\d+ client login failed: "Authentication credentials invalid" while in http auth state, client: <HOST>, server: \S+, login: "<F-USER>\S+</F-USER>"$
ignoreregex =
```

```
fail2ban-client reload
fail2ban-client status mailu
```

## sendmail

```bash
yay -S sendmail
```

## cfddns

Dynamic DNS for Cloudflare.

```
yay -S cfddns
```

```yml /etc/cfddns/cfddns.yml
token: <token>
```

```ini /etc/cfddns/domains
uechi.io
datastore.uechi.io
```

```
systemctl enable --now cfddns
```

## smart

```bash
pacman -S smartmontools
systemctl enable --now smartd

smartctl -t short /dev/sdc
smartctl -l selftest /dev/sdc
```

## backup

```bash
pacman -S borg
```

```ini /etc/backups/borg.service
[Unit]
Description=Borg Daily Backup Service

[Service]
Type=simple
Nice=19
IOSchedulingClass=2
IOSchedulingPriority=7
ExecStart=/etc/backups/run.sh
```

```ini /etc/backups/borg.timer
[Unit]
Description=Borg Daily Backup Timer

[Timer]
WakeSystem=false
OnCalendar=*-*-* 03:00
RandomizedDelaySec=10min

[Install]
WantedBy=timers.target
```

```bash /etc/backups/run.sh
#!/bin/bash -ue

# The udev rule is not terribly accurate and may trigger our service before
# the kernel has finished probing partitions. Sleep for a bit to ensure
# the kernel is done.
#
# This can be avoided by using a more precise udev rule, e.g. matching
# a specific hardware path and partition.
sleep 5

#
# Script configuration
#
export BORG_PASSPHRASE="<secret>"
MOUNTPOINT=/mnt/backup
TARGET=$MOUNTPOINT/borg

# Archive name schema
DATE=$(date --iso-8601)

#
# Create backups
#

# Options for borg create
BORG_OPTS="--stats --compression lz4 --checkpoint-interval 86400"

# No one can answer if Borg asks these questions, it is better to just fail quickly
# instead of hanging.
export BORG_RELOCATED_REPO_ACCESS_IS_OK=no
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=no

# Log Borg version
borg --version

echo "Starting backup for $DATE"

echo "# system"
borg create $BORG_OPTS \
  --exclude /var/cache \
  --exclude /var/lib/docker/devicemapper \
  --exclude /root/.cache \
  --exclude /root/.pyenv \
  --exclude /root/.vscode-server \
  --exclude /root/.local/share/TabNine \
  --exclude 'sh:/home/*/.cache' \
  --exclude 'sh:/home/*/.cargo' \
  --exclude 'sh:/home/*/.pyenv' \
  --exclude 'sh:/home/*/.vscode-server' \
  --exclude 'sh:/home/*/.local/share/TabNine' \
  --one-file-system \
  $TARGET::'{hostname}-system-{now}' \
  / /boot

echo "# data"
borg create $BORG_OPTS \
  --exclude 'sh:/mnt/data/nextcloud/appdata_*/preview' \
  --exclude 'sh:/mnt/data/nextcloud/appdata_*/dav-photocache' \
  $TARGET::'{hostname}-data-{now}' \
  /mnt/data

echo "# archive"
borg create $BORG_OPTS \
  $TARGET::'{hostname}-archive-{now}' \
  /mnt/archive

echo "# ftl"
borg create $BORG_OPTS \
  $TARGET::'{hostname}-ftl-{now}' \
  /mnt/ftl

echo "Start pruning"
BORG_PRUNE_OPTS_NORMAL="--list --stats --keep-daily 7 --keep-weekly 3 --keep-monthly 2"
BORG_PRUNE_OPTS_LESS="--list --stats --keep-daily 3 --keep-weekly 1 --keep-monthly 1"
borg prune $BORG_PRUNE_OPTS_NORMAL --prefix '{hostname}-system-' $TARGET
borg prune $BORG_PRUNE_OPTS_NORMAL --prefix '{hostname}-archive-' $TARGET
borg prune $BORG_PRUNE_OPTS_LESS   --prefix '{hostname}-data-' $TARGET
borg prune $BORG_PRUNE_OPTS_LESS   --prefix '{hostname}-ftl-' $TARGET

echo "Completed backup for $DATE"

# Just to be completely paranoid
sync
```

```bash
ln -sf /etc/backups/borg.* /etc/systemd/system/
systemctl enable --now borg
```

## Kubernetes

```bash
pacman -S kubeadm kubelet kubectl
systemctl enable --now kubelet
kubeadm init --pod-network-cidr='10.244.0.0/16'
cp /etc/kubernetes/admin.conf ~/.kube/config

kubectl taint nodes --all node-role.kubernetes.io/master- # to allow allocating pods to the master node

# setup flannel network manager
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# setup nginx ingress controller
# TODO

kubectl cluster-info
kubectl get nodes
kubectl get pods -A
kubectl get cm -n kube-system kubeadm-config -o yaml
```

- [Kubernetes - ArchWiki](https://wiki.archlinux.org/index.php/Kubernetes)
- [Kubernetes Ingress Controller with NGINX Reverse Proxy and Wildcard SSL from Let's Encrypt - Shogan.tech](https://www.shogan.co.uk/kubernetes/kubernetes-ingress-controller-with-nginx-reverse-proxy-and-wildcard-ssl-from-lets-encrypt/)

## certs

```bash
pacman -S certbot certbot-dns-cloudflare
echo "dns_cloudflare_api_token = <token>" > ~/.secrets/certbot/cloudflare.ini
chmod 600 ~/.secrets/certbot/cloudflare.ini
certbot certonly \
  --email y@uechi.io \
  --agree-tos \
  --dns-cloudflare \
  --dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini \
  -d "*.uechi.io"
openssl x509 -in /etc/letsencrypt/live/uechi.io/fullchain.pem -text
certbot certificates
```

```ini /etc/systemd/system/certbot.service
[Unit]
Description=Let's Encrypt renewal

[Service]
Type=oneshot
ExecStart=/usr/bin/certbot renew --quiet --agree-tos --deploy-hook "docker exec nginx-proxy-le /app/signal_le_service"
```

```ini /etc/systemd/system/certbot.timer
[Unit]
Description=Twice daily renewal of Let's Encrypt's certificates

[Timer]
OnCalendar=0/12:00:00
RandomizedDelaySec=1h
Persistent=true

[Install]
WantedBy=timers.target
```

- [Certbot - ArchWiki](https://wiki.archlinux.org/index.php/Certbot)
- [Welcome to certbot-dns-cloudflare’s documentation! — certbot-dns-cloudflare 0 documentation](https://certbot-dns-cloudflare.readthedocs.io/en/stable/)
- [docker-letsencrypt-nginx-proxy-companion/Standalone-certificates.md at master · nginx-proxy/docker-letsencrypt-nginx-proxy-companion](https://github.com/nginx-proxy/docker-letsencrypt-nginx-proxy-companion/blob/master/docs/Standalone-certificates.md)

## audio

```bash
pacman -S alsa-utils # maybe requires reboot
usermod -aG audio uetchy

# list devices as root
aplay -l
arecord -L
cat /proc/asound/cards

# test speaker
speaker-test -c2

# test mic
arecord -vv -Dhw:2,0 -fS32_LE mic.wav
aplay mic.wav

# gui mixer
alsamixer

# for Mycroft.ai
pacman -S pulseaudio pulsemixer
pulseaudio --start
pacmd list-cards
```

```conf /etc/pulse/default.pa
# INPUT/RECORD
load-module module-alsa-source device="default" tsched=1
# OUTPUT/PLAYBACK
load-module module-alsa-sink device="default" tsched=1
# Accept clients -- very important
load-module module-native-protocol-unix
load-module module-native-protocol-tcp
```

```conf /etc/asound.conf
pcm.mic {
  type hw
  card M96k
  rate 44100
  format S32_LE
}

pcm.speaker {
  type plug
  slave {
    pcm "hw:1,0"
  }
}

pcm.!default {
  type asym
  capture.pcm "mic"
  playback.pcm "speaker"
}

#defaults.pcm.card 1
#defaults.ctl.card 1
```

- [PulseAudio as a minimal unintrusive dumb pipe to ALSA](https://wiki.archlinux.org/title/PulseAudio/Examples#PulseAudio_as_a_minimal_unintrusive_dumb_pipe_to_ALSA)
- [SoundcardTesting - AlsaProject](https://www.alsa-project.org/main/index.php/SoundcardTesting)
- [Advanced Linux Sound Architecture/Troubleshooting - ArchWiki](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture/Troubleshooting#Microphone)
- [ALSA project - the C library reference: PCM (digital audio) plugins](https://www.alsa-project.org/alsa-doc/alsa-lib/pcm_plugins.html)
- [Asoundrc - AlsaProject](https://www.alsa-project.org/wiki/Asoundrc)

# Maintenance

## system healthcheck

```bash
systemctl --failed # show failed units
free -h # show memory usage
lsblk -f # show disk usage
networkctl status # show network status
userdbctl # show users
nvidia-smi # verify nvidia cards
htop # show task overview
neofetch # show system info
```

## analyzing logs

```bash
journalctl -p err -b-1 -r # show error logs from previous boot in reverse order
journalctl CONTAINER_NAME=service_web_1 # show error from docker container named 'service_web_1'
journalctl -u docker -f # tail docker logs
```

# Common Issues

## Longer SSH login (D-bus glitch)

```bash
systemctl restart systemd-logind
systemctl restart polkit
```

- [A comprehensive guide to fixing slow SSH logins – JRS Systems: the blog](https://jrs-s.net/2017/07/01/slow-ssh-logins/)

## Annoying `systemd-homed is not available` log messages

Move `pam_unix` before `pam_systemd_home`.

```ini /etc/pam.d/system-auth
#%PAM-1.0

auth       required                    pam_faillock.so      preauth
# Optionally use requisite above if you do not want to prompt for the password
# on locked accounts.
auth       [success=2 default=ignore]  pam_unix.so          try_first_pass nullok
-auth      [success=1 default=ignore]  pam_systemd_home.so
auth       [default=die]               pam_faillock.so      authfail
auth       optional                    pam_permit.so
auth       required                    pam_env.so
auth       required                    pam_faillock.so      authsucc
# If you drop the above call to pam_faillock.so the lock will be done also
# on non-consecutive authentication failures.

account    [success=1 default=ignore]  pam_unix.so
-account   required                    pam_systemd_home.so
account    optional                    pam_permit.so
account    required                    pam_time.so

password   [success=1 default=ignore]  pam_unix.so          try_first_pass nullok shadow
-password  required                    pam_systemd_home.so
password   optional                    pam_permit.so

session    required                    pam_limits.so
session    required                    pam_unix.so
session    optional                    pam_permit.so
```

- [[solved] pam fails to find unit dbus-org.freedesktop.home1.service / Newbie Corner / Arch Linux Forums](https://bbs.archlinux.org/viewtopic.php?id=258297)

## Annoying systemd-journald-audit log

```ini /etc/systemd/journald.conf
Audit=no
```

## Missing `/dev/nvidia-{uvm*,modeset}`

This occurs after updating linux kernel. Simply reinstall `nvidia-container-toolkit`.

# Useful links

- [General recommendations](https://wiki.archlinux.org/index.php/General_recommendations#Users_and_groups)
- [System maintenance](https://wiki.archlinux.org/index.php/System_maintenance)
- [Improving performance](https://wiki.archlinux.org/index.php/Improving_performance#Know_your_system)
- [Benchmarking - ArchWiki](https://wiki.archlinux.org/index.php/Benchmarking)
