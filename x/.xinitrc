# Disable beep
# xset -b

# xrandr
xrandr --output DP-4 --right-of HDMI-1 --rate 144
# xrandr --output HDMI-1 --primary --left-of DP-0

# Set keyboard (in x) to dk
setxkbmap -layout dk

# Start compositor for fancy visuals
#picom --experimental-backends &
picom &

# Unclutter - hide the mouse cursor
unclutter --jitter 10 --ignore-scrolling --start-hidden --fork

# Flameshot process (Screenshots)
flameshot &

# Nitrogen for wallpaper
# nitrogen --set-zoom-fill ~/Pictures/wallpaper.png &
nitrogen --restore

# Start qtile window manager
qtile start

# This command puts the user back in TTY, if qtile stops, so you can restart X server (for updated changes to this file)
# WARNING: Seems unsafe for now, at least it literally clears, and I can't get to a TTY
# clear 
