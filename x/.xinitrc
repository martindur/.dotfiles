# Disable beep
# xset -b

# Set keyboard (in x) to dk
setxkbmap -layout dk

# Start compositor for fancy visuals
# picom &

# Unclutter - hide the mouse cursor
unclutter --jitter 10 --ignore-scrolling --start-hidden --fork

# Nitrogen for wallpaper
nitrogen --set-zoom-fill ~/Pictures/carina-nebula.png &

# Start qtile window manager
qtile start

# This command puts the user back in TTY, if qtile stops, so you can restart X server (for updated changes to this file)
# WARNING: Seems unsafe for now, at least it literally clears, and I can't get to a TTY
# clear 
