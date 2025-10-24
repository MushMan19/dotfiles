#!/bin/bash
# ── brightness.sh ─────────────────────────────────────────
# Description: Shows current brightness with ASCII bar + tooltip
# Usage: Waybar `custom/brightness` every 2s
# Dependencies: brightnessctl, awk, printf
# ──────────────────────────────────────────────────────────

# Get brightness percentage safely
brightness=$(brightnessctl get 2>/dev/null)
max_brightness=$(brightnessctl max 2>/dev/null)

# Fallback to 0 if any command failed
if [ -z "$brightness" ] || [ -z "$max_brightness" ] || [ "$max_brightness" -eq 0 ]; then
  percent=0
else
  percent=$((brightness * 100 / max_brightness))
fi

# Clamp between 0–100
if [ "$percent" -lt 0 ]; then percent=0; fi
if [ "$percent" -gt 100 ]; then percent=100; fi

# Build ASCII bar with fixed length = 10
total=10
filled=$((percent / (100 / total)))
if [ "$filled" -lt 0 ]; then filled=0; fi
if [ "$filled" -gt "$total" ]; then filled=$total; fi
empty=$((total - filled))

bar=""
pad=""

if [ "$filled" -gt 0 ]; then
  for _ in $(seq 1 "$filled"); do
    bar="${bar}█"
  done
fi

if [ "$empty" -gt 0 ]; then
  for _ in $(seq 1 "$empty"); do
    pad="${pad}░"
  done
fi

ascii_bar="[$bar$pad]"

fg="#CED7F2"

# Color thresholds
if [ "$percent" -lt 10 ]; then
  # fg="#bf616a"  # red
  icon="🌕"
elif [ "$percent" -lt 25 ]; then
  icon="🌔"
  # fg="#fab387"  # orange
elif [ "$percent" -lt 50 ]; then
  icon="🌓"
  # fg="#fab387"  # orange
elif [ "$percent" -lt 90 ]; then
  icon="🌒"
  # fg="#fab387"  # orange
else
  icon="🌑"
  # fg="#56b6c2"  # cyan
fi

# Device name (first field from brightnessctl --machine-readable)
device=$(brightnessctl --machine-readable | awk -F, 'NR==1 {print $1}')
[ -z "$device" ] && device="Display"

# Tooltip
tooltip="Brightness: $percent%\nDevice: $device"

# Pad percentage to fixed width (3 digits)
percent_str=$(printf "%3d%%" "$percent")

printf '%s\n' "{\"text\":\"<span font='JetBrainsMono Nerd Font Mono' size='large'><span foreground='$fg'>[$icon]</span></span>\",\"tooltip\":\"$tooltip\"}"
