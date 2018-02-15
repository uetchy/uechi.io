---
title: How can I rescued almost data from damaged HDD
date: 2018-02-15 12:45:00 +09:00
---

This is a complete guide describes how to rescue your data from old and wrecked HDD.

Suppose you are using macOS and your endangered disk is formatted with HFS+.

# Beforehand

## Inspect
Use `diskutil list` to verify that which drive is what you expected for.
This article assumes that `disk2` is the damaged one AND a partition `disk2s2` is what you expected to be rescued.

## Damage Control
To prevent extra load, unmount the damaged disk: `diskutil unmountDisk disk2`.

# Rescue
If you never been `ddrescue`, `brew install ddrescue` to install them on your machine.

```bash
cd /Volumes/AnotherDriveLargerThanDamagedDrive
sudo ddrescue -n -v /dev/disk2s2 ./hdimage.dmg ./mapfile
```

So this command will start rescuing your data from `/dev/disk2s2` partition to `hdimage.dmg` while writing log to `mapfile`.
You might want to rescue data as fast as possible. option `-n` is here for. This will skip scraping phase that causes aggressive disk access. 
Option `-v` stand for verbose logging.

```bash
sudo ddrescue -r5 -v /dev/rdisk2s2 ./hdimage.dmg ./mapfile
```

When the first command completed, do it again with different parameters to aggressively scrape bad area failed to access the first time.
Option `-r5` means ddrescue will try rescuing damaged area for 5 times.
And `/dev/disk2s2` become `/dev/__r__disk2s2` this time. `r` stand for raw so this will access the disk more direct way.

# Aftercare

Mount hdimage.dmg and copy files and directories to a new drive. If the image seems broken, you can recover using `testdisk`. 