# Web Apps Guide

This guide shows you how to install and manage web applications that launch in their own windows via Rofi.

## What are Webapps?

Webapps are websites that run in a dedicated Chromium window without browser chrome (no tabs, address bar, etc.). They appear as native applications in your system and can be launched via Rofi.

## Pre-installed Webapps

After running `install.sh`, you'll have:

- **ChatGPT** - https://chatgpt.com/
- **Discord** - https://discord.com/channels/@me

## Installing New Webapps

### Interactive Mode (Recommended)

```bash
webapp-install
```

You'll be prompted for:
1. **Name** - The display name (e.g., "Gmail")
2. **URL** - The website URL (e.g., "https://mail.google.com")
3. **Icon URL** - PNG icon URL (see [Dashboard Icons](https://dashboardicons.com))

### Command Line Mode

```bash
webapp-install "App Name" "https://url.com" "https://icon-url.png"
```

Examples:
```bash
# Gmail
webapp-install "Gmail" "https://mail.google.com" "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/gmail.png"

# GitHub
webapp-install "GitHub" "https://github.com" "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/github.png"

# Notion
webapp-install "Notion" "https://notion.so" "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/notion.png"

# Slack
webapp-install "Slack" "https://app.slack.com" "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/slack.png"

# YouTube Music
webapp-install "YouTube Music" "https://music.youtube.com" "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/youtube-music.png"
```

## Launching Webapps

### Via Rofi

1. Press your Rofi keybinding (usually `Mod+d` in i3)
2. Type the webapp name
3. Press Enter

### Via Command Line

```bash
webapp-launch "https://url.com"
```

Or launch an installed webapp by its name:
```bash
# Launch the .desktop file
gtk-launch "ChatGPT"
```

## Removing Webapps

### Interactive Mode

```bash
webapp-remove
```

Select the webapp to remove using fzf.

### Command Line Mode

```bash
webapp-remove "App Name"
```

Example:
```bash
webapp-remove "Discord"
```

## Finding Icons

### Dashboard Icons (Recommended)

Visit [https://dashboardicons.com](https://dashboardicons.com) and search for your app.

Copy the PNG URL, for example:
```
https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/gmail.png
```

### Other Sources

- Official app websites (look for PNG logos)
- [SimpleIcons](https://simpleicons.org/)
- [Iconify](https://icon-sets.iconify.design/)

**Note:** Icons must be PNG format and publicly accessible via HTTP/HTTPS.

## i3 Integration

### Keybinding Example

Add to your `~/.config/i3/config`:

```
# Launch specific webapps
bindsym $mod+Shift+g exec gtk-launch "Gmail"
bindsym $mod+Shift+c exec gtk-launch "ChatGPT"
bindsym $mod+Shift+d exec gtk-launch "Discord"
```

### Workspace Assignment

Assign webapps to specific workspaces:

```
# Assign Discord to workspace 4
assign [class="Chromium" title="Discord"] $ws4

# Assign ChatGPT to workspace 3
assign [class="Chromium" title="ChatGPT"] $ws3
```

### Floating Mode

Make specific webapps float:

```
for_window [class="Chromium" title="Calculator"] floating enable
```

## Webapp Directory Structure

Webapps are stored in standard XDG locations:

```
~/.local/share/applications/
├── ChatGPT.desktop
├── Discord.desktop
├── Gmail.desktop
└── icons/
    ├── ChatGPT.png
    ├── Discord.png
    └── Gmail.png
```

## Troubleshooting

### Webapp not appearing in Rofi

1. Check if the .desktop file exists:
   ```bash
   ls ~/.local/share/applications/*.desktop
   ```

2. Update desktop database:
   ```bash
   update-desktop-database ~/.local/share/applications/
   ```

3. Restart Rofi or press `Mod+d` again

### Icon not showing

1. Check if icon was downloaded:
   ```bash
   ls ~/.local/share/applications/icons/
   ```

2. Verify icon URL is accessible:
   ```bash
   curl -I "https://icon-url.png"
   ```

3. Re-install the webapp with a different icon URL

### Webapp launches in regular browser

This means Chromium is not set as the handler. Check:

```bash
which webapp-launch
```

If not found, reinstall helper scripts:
```bash
cd ~/.dotfiles
make linux-arch
```

### Multiple windows of same webapp

Chromium treats each webapp instance separately. To focus existing windows:

1. Use i3's focus commands
2. Or create a wrapper script that checks if window exists first

## Popular Webapps to Install

### Productivity
- Gmail: `https://mail.google.com`
- Google Calendar: `https://calendar.google.com`
- Notion: `https://notion.so`
- Todoist: `https://todoist.com/app`
- Trello: `https://trello.com`

### Communication
- WhatsApp: `https://web.whatsapp.com`
- Telegram: `https://web.telegram.org`
- Slack: `https://app.slack.com`

### Development
- GitHub: `https://github.com`
- GitLab: `https://gitlab.com`
- Figma: `https://figma.com`
- Excalidraw: `https://excalidraw.com`

### Media
- YouTube Music: `https://music.youtube.com`
- Spotify: `https://open.spotify.com`
- Netflix: `https://netflix.com`

### Social
- X (Twitter): `https://x.com`
- LinkedIn: `https://linkedin.com`
- Reddit: `https://reddit.com`

## Advanced Usage

### Custom Exec Commands

For webapps that need special handling, modify the .desktop file:

```bash
vim ~/.local/share/applications/MyApp.desktop
```

Change the `Exec=` line:
```
Exec=webapp-launch "https://example.com" --arg1 --arg2
```

### Profile Isolation

To completely isolate webapps with separate profiles:

```bash
chromium --user-data-dir="$HOME/.config/chromium-profiles/gmail" --app="https://mail.google.com"
```

### Custom User Agent

Some sites work better with specific user agents:

```bash
chromium --app="https://example.com" --user-agent="Mozilla/5.0..."
```

## Tips

- Use descriptive names for easy searching in Rofi
- Group related webapps on the same workspace in i3
- Consider using Chromium profiles for different accounts
- Webapps respect your system dark/light theme
- Use `Ctrl+Shift+I` in webapp to open DevTools
- Clear webapp data: `chromium --app-id=<app-id>` then clear storage

## Uninstalling

To remove all webapps and cleanup:

```bash
# Remove all .desktop files
rm ~/.local/share/applications/*.desktop

# Remove icons
rm -rf ~/.local/share/applications/icons/

# Update database
update-desktop-database ~/.local/share/applications/
```

## See Also

- Main README: `linux/arch/setup/README.md`
- i3 Configuration: `~/.config/i3/config`
- Rofi Configuration: `~/.config/rofi/`
