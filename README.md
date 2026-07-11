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

`configuration.nix` is system configuration rather than a home dotfile, so it
stays outside the Stow package.

## Install

```bash
make install
```

Remove the managed links with:

```bash
make delete
```

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

## NixOS

```bash
make nix
make nix-upgrade
```
