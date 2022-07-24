# Arch for Dummies!

A collection of easy-to-understand tidbits on handling Arch Linux, such as installing the base system, common usage commands etc.


## Architectural basics

When you think of a "normal" OS, like Windows or MacOS, you quickly assume that an OS comes with a desktop environment, file manager, network manager and a plethora of other tools to give you an easy setup!

Well, Linux is different, or rather Arch Linux is different. Linux is really just the underlying core for a range of other operation systems. One of the most popular ones being Ubuntu, which tries to fit into the sphere of a "normal" OS, in the open source space.

Another popular one, is Arch. It is quite the opposite of Ubuntu, instead of giving you the Linux kernel and a lot of extra software to give you that "normal" desktop. It'll give you the kernel, a package manager (Pacman), and a few necessary tools, but other than that, you're left alone to customize your own OS. Good luck with that!


## Install the base

For a more in depth article, this source is great: https://freecodecamp.org/news/how-to-install-arch-linux

### Install medium(USB)

If you don't have a an install medium.... always have an install medium with Arch, it'll be your future rescue! Mark my words!


1. download Arch
```
curl http://mirrors.dotsrc.org/archlinux/iso/latest/archlinux-x86_64.iso -o ~/Downloads/archlinux-x86_64.iso
```

2. Insert your install medium and find it
`lsblk` - identify it as `/dev/sdx` where `x` is probably another letter in your case. Make sure it is not mounted.

3. Arch2USB
```
dd bs=4M if=~/Downloads/archlinux-x86_64.iso of=/dev/sdx conv=fsync oflag=direct status=progress
```


### Installation


#### Preconfigure

1. Make sure you're in UEFI, select the default option from the install medium, and voila, you should end up in a TTY

2. `loadkeys dk` - Load a keymap that fits your keyboard layout. (Available selection in `/usr/share/kbd/keymaps`)

3. Make sure you're connected to the internet. 
  a. LAN: `ping 8.8.8.8` - getting response? You're good to go.
  b. WIFI: If it's not a USB adapter, run:
    * `iwctl`
    * `device list` (find your device on list, let's assume it's called wlan0)
    * `station wlan0 scan` (scans for networks)
    * `station wlan0 get-networks` (lists networks found from scan)
    * `station wlan0 connect <network>
    * Input password when prompted, and then run `exit`
  c. WIFI USB DONGLE: Ouch! Good luck..

4. `timedatectl set-ntp true` - Update system clock

#### Partitioning

Gotta format and partition disks yourself good fellow!

1. List partition tables for available devices (HDD, SSD, NVME)
```
fdisk -l
```
2. Find disk you want to partition for installation, let's say it's `/dev/sda`
3. Lists partitions for selected device (Just make sure the selection is correct, etc.)
```
fdisk /dev/sda -l
```

`fdisk` helps us list and locate disks, but for partitioning, we might want to rely on a tool called `cfdisk`, which provides us with a TUI, and can make partitioning a lot easier and intuitive. Which is important when a wrong move could delete all those precious pictures of your holiday to Bali, along with everything else.

4. "Open" the selected disk. You'll either see existing partitions, or need to select a label type. In case of the latter, select `gpt` for UEFI baed system.
```
cfdisk /dev/sda
```

5. If you have existing partitions, you can either delete them all, and reclaim the free space, or use the existing free space. This guide is for 1 disk 1 OS, so if you want to dual-boot OSes on the same drive, you might want to look for a dedicated guide. I'm assuming your starting point here is *all* the free space.
6. Create three partitions, using the `New` choice on free space selection, and use the `Type` choice to change type.
  a. EFI system partition - files required by the UEFI firmware. Size: `500M` Type: `EFI System`
  b. SWAP - Serving as the overflow space for your RAM. Size: `1.5G` Type: `Linux swap`
  c. ROOT - partition to hold Arch itself. Size: (Rest of it? Use G for gigabytes, and T for terabytes) Type: `Linux filesystem`
7. Select the `Write` choice, type out "yes", and now select `Quit`, as the partition table has been altered.
8. Check the new partition names: `fdisk /dev/sda -l` `/dev/sda1`, `/dev/sda2`, `/dev/sda3`.
9. Time to format them! EFI needs to be FAT32
```
mkfs.fat -F32 /dev/sda1
```
10. Next is for swap memory
```
mkswap /dev/sda2
```
11. Last is our distribution. There are various you could choose from, let's stick to EXT4
```
mkfs.ext4 /dev/sda3
```

And that's it! We're partitioned and formatted.

#### Mounting

1. Mount our main partition to get access (`/mnt` is used for mounting temporary devices, good while installing)
```
mount /dev/sda3 /mnt
```
2. Explicitly set swap
```
swapon /dev/sda2
```

#### Configure Mirrors

Add a list of mirrors that are suitably close to your region (used by Pacman package manager)
Use `reflector` to filter for suitable mirrors, and store them in the mirrorlist

1. Backup mirrorlist first

```
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
```

2. Update mirrorlist
```
reflector --country Denmark,Sweden --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```

#### Installing the Base System

1. Update package cache according to the new mirror list
```
pacman -Sy
```

2. Use `pacstrap` to install packages to a specified new root directory.
```
pacstrap /mnt base base-devel linux linux-firmware sudo nvim ntfs-3g networkmanager
``` 

These are not all "essential", but `nvim` is useful as a text editor for further configuration (You can also replace it with `nano`), and networkmanager makes it easier to configure networks.

Congratulations! Arch linux is now installed! It's not bootable, but installed!
