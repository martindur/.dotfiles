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
`curl http://mirrors.dotsrc.org/archlinux/iso/latest/archlinux-x86_64.iso -o ~/Downloads/archlinux-x86_64.iso`

2. Insert your install medium and find it
`lsblk` - identify it as `/dev/sdx` where `x` is probably another letter in your case. Make sure it is not mounted.

3. Arch2USB
`dd bs=4M if=~/Downloads/archlinux-x86_64.iso of=/dev/sdx conv=fsync oflag=direct status=progress`


### Installation

1. Do it! WIP
