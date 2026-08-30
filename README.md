# Dotfiles

Personal home configuration managed as one GNU Stow package.

## Layout

`home/` mirrors the home directory. Configuration for Linux and macOS lives
together because tools ignore configuration for programs that are not
installed.

```text
home/
├── .bashrc
├── .profile
├── .config/
├── .local/bin/
└── AGENTS.md
```

System configuration templates such as `greetd.conf` and `earlyoom.conf` stay
outside the Stow package.

## Install

```bash
make install
```

If Arch's default Sway file already exists at `~/.config/sway/config`, move it
aside first so Stow can create the managed link.

Remove the managed links with:

```bash
make delete
```

On an Arch laptop, enable memory-pressure protection with:

```bash
make laptop
```

Install the tuigreet login configuration and enable greetd with:

```bash
make greetd
```

The Sway config uses Swaybar with i3status for the status line. Install Sway,
SwayIdle, SwayLock, tuigreet, i3status, grim, slurp, wl-clipboard,
NetworkManager's applet, polkit-gnome, brightnessctl, and
`ttf-cascadia-code-nerd` through Arch's package manager as needed. The last
package provides the icons used by i3status.

## Webapps

`webapp` creates desktop entries that Rofi discovers and launches in a
dedicated Chromium window.

```bash
webapp add NAME URL [ICON]
webapp remove NAME
webapp list
```

`ICON` may be an icon theme name or a local file path. Set `WEBAPP_BROWSER` to
override the default Chromium executable.
