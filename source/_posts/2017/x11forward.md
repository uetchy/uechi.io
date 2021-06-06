---
title: Forward X11 window over SSH
date: 2017-06-16 00:00:00 +09:00
redirect_from: "/blog/2017/06/16/x11forward"
---

![](/uploads/x11-plot.png)

# Installation

## Remote

### Arch Linux

```bash
pacman -S xorg-xauth xorg-fonts-100dpi xorg-xeyes
```

### Ubuntu 16.04

Make sure you have installed SSH, X11 and xAuth on a remote server.

```
sudo apt install -y xorg xauth openssh
sudo sed -i '/ForwardX11/s/.*/ForwardX11 yes/' /etc/ssh/sshd_config
sudo service ssh restart
```

## Client (macOS Big Sur)

You also need to have X11 on your local machine.

```
brew install xquartz # install X11
ssh -X <remote>
$ xeyes # verify you have X11
```

You might want to restart macOS if `$DISPLAY` have empty value.

# Plot with matplotlib

Plot a simple graph remotely on Ubuntu 16.04:

```python
import matplotlib.pyplot as plt
plt.plot([1, 2, 3])
plt.show()
```

If you can't see any window, add **backend** settings to `~/.config/matplotlib/matplotlibrc`.

```ini
backend: TkAgg
```

or just add few lines to change the backend explicitly:

```python
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
...
```
