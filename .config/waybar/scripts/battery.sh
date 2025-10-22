#!/bin/bash
# ── battery.sh ─────────────────────────────────────────────
# Description: Shows battery % with ASCII bar + dynamic tooltip
# Usage: Waybar `custom/battery` every 10s
# Dependencies: upower, awk, printf
# Font: Electroharmonix (ensure it's installed)
# ──────────────────────────────────────────────────────────

# Paths
BAT_PATH="/sys/class/power_supply/BAT0"

# Read capacity and status safely
capacity=$(cat "$BAT_PATH/capacity" 2>/dev/null)
status=$(cat "$BAT_PATH/status" 2>/dev/null)

# Fallback if unavailable
[ -z "$capacity" ] && capacity=0
[ -z "$status" ] && status="Unknown"

# Get detailed info (optional)
upower_path="/org/freedesktop/UPower/devices/battery_BAT0"
time_to_empty=$(upower -i "$upower_path" 2>/dev/null | awk -F: '/time to empty/ {print $2}' | xargs)
time_to_full=$(upower -i "$upower_path" 2>/dev/null | awk -F: '/time to full/ {print $2}' | xargs)

# Icons
charging_icons=(󰢜 󰂆 󰂇 󰂈 󰢝 󰂉 󰢞 󰂊 󰂋 󰂅)
default_icons=(󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)

index=$((capacity / 10))
[ "$index" -ge 10 ] && index=9

if [[ "$status" == "Charging" ]]; then
    icon=${charging_icons[$index]}
elif [[ "$status" == "Full" ]]; then
    icon="󰂅"
else
    icon=${default_icons[$index]}
fi

# ASCII bar (stable-width method)
total=10
filled=$((capacity / (100 / total)))
[ "$filled" -lt 0 ] && filled=0
[ "$filled" -gt "$total" ] && filled=$total
empty=$((total - filled))

bar=""
pad=""
if [ "$filled" -gt 0 ]; then
  for _ in $(seq 1 "$filled"); do bar="${bar}█"; done
fi
if [ "$empty" -gt 0 ]; then
  for _ in $(seq 1 "$empty"); do pad="${pad}░"; done
fi
ascii_bar="[$bar$pad]"

# Color thresholds
if [ "$capacity" -lt 20 ]; then
    fg="#bf616a"  # red
elif [ "$capacity" -lt 55 ]; then
    fg="#fab387"  # orange
else
    fg="#56b6c2"  # cyan
fi

# Tooltip logic
if [[ "$status" == "Charging" ]]; then
  tooltip="Status: Charging\nBattery: ${capacity}%\nCharges in: ${time_to_full:-Unknown}"
elif [[ "$status" == "Discharging" ]]; then
  tooltip="Status: Discharging\nBattery: ${capacity}%\nLasts: ${time_to_empty:-Unknown}"
else
  tooltip="Status: $status\nBattery: ${capacity}%"
fi

# Fixed-width percent (3 characters: ' 90%', '100%', etc)
percent_str=$(printf "%3d%%" "$capacity")

# JSON output
printf '%s\n' "{\"text\":\"<span font='Electroharmonix'><span foreground='$fg'>[ $icon ]</span></span>\",\"tooltip\":\"$tooltip\"}"
