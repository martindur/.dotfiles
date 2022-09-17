

# Arch setup


## Install


Install USB

```
curl http://mirrors.dotsrc.org/archlinux/iso/latest/archlinux-x86_64.iso -o ~/Downloads/archlinux-x86_64.iso
```

```
lsblk
```
* Example with USB being found on `/dev/sda`

```
dd bs=4M if=~/Downloads/archlinux-x86_64.iso of=/dev/sda conv=fsync oflag=direct status=progress
```

Boot from USB, end up in TTY

```
loadkeys dk
```

LAN:
```
ping 8.8.8.8
```
WIFI:
1. `iwctl`
2. `device list`
3. `station <device> scan`
4. `station <device> get-networks`
5. `station <device> connect <network>`
6. Input password, profit!


iwctl might have network configuration disabled. In that case, create a `etc/iwd/main.conf` file with content:

```
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd
```

And run
```
systemctl restart iwd.service
```


System clock:
```
timedatectl set-ntp true
```

Partition: (Read more in Dummy)
```
fdisk -l
```
```
fdisk /dev/sda -l
```
```
cfdisk /dev/sda
```

Partition table:
1. `EFI Partition (sda1) - Size: 500M, Type: EFI System`
2. `SWAP (sda2) - Size: 1.5G, Type: Linux swap`
3. `ROOT (sda3) - Size: Rest, Type: Linux filesystem`

Format:
```
mkfs.fat -F32 /dev/sda1 && mkswap /dev/sda2 && mkfs.ext4 /dev/sda3
```

Mounting:
```
mount /dev/sd3 /mnt && swapon /dev/sda2
```

Set up mirrors:
```
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && reflector --country Denmark,Sweden --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```
```
pacman -Sy
```


### Base Packages (Pre-boot)

These are base packages (and some opinionated ones) we install *before* booting into the system, as we still have more configuration needed

```
pacstrap /mnt base base-devel linux linux-firmware intel-ucode sudo nvim ntfs-3g networkmanager iwd
```

### Boot loader

```
genfstab -U /mnt >> /mnt/etc/fstab
```

```
arch-chroot /mnt
```

```
mkdir /boot/efi && mount /dev/sda1 /boot/efi
```

```
pacman -S grub efibootmgr os-prober && grub-install --target=x86_64-efi --bootloader-id=grub
```

To enable OS prober (for dual-booting), open `/etc/default/grub` and uncomment:
```
#GRUB_DISABLE_OS_PROBER=false
```

```
grub-mkconfig -o /boot/grub/grub.cfg
```

```
umount /mnt
```

### Root login

```
passwd
```

Reboot!


## Configure 


### Network, locale and time

```
ln -sf /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime
```

Set languages by uncommenting lines from `/etc/locale.gen`, like:
* `en_US.UTF-8 UTF-8`
* `da_DK.UTF-8 UTF-8`

```
locale-gen
```

Set default language in `/etc/locale.conf`
```
LANG=da_DK.UTF-8
```

Set keymapping for virtual console, edit `/etc/vconsole.conf`
```
KEYMAP=dk
```

Update hostname in `/etc/hostname`
```
bestgenericname
```

Update `/etc/hosts`
```
127.0.0.1   localhost
::11        localhost
127.0.1.1   bestgenericname
```

```
systemctl enable NetworkManager
```

### Users and sudo


```
useradd -m -G wheel bob
```

```
passwd bob
```

Uncomment line in `/etc/sudoers`
```
%wheel ALL=(ALL) ALL
```

### Additional packages

```
pacman -S \
    xorg-server xorg-xinit \
    nvidia nvidia-utils \
    openssh \
    nvim \
    qtile \
    alacritty \
    fish \
    picom \
    nitrogen \
    pulseaudio \
    unclutter \
    unzip \
    git \
    ripgrep \
    docker \
    docker-compose \
    go \
    firefox \
    blender \
    fzf \
    stow \
    tmux
```

Yay AUR helper:
```
git clone https://aur.archlinux.org/yay-git.git && cd yay-git && makepkg -si
```

```
yay -S \
    1password \
    nerd-fonts-fira-code \
    heroku-cli \
    flameshot \
    slack-desktop
```


## GUI, WM etc. (Dotfiles)

```
cd ~ && \
git clone https://github.com/martindur/.dotfiles && \
cd .dotfiles && \
./install
```
