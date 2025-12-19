#!/bin/sh
# gen_alacritty.sh
# Generate Alacritty color config from theme JSON

set -eu

THEME_JSON="$1"
OUT="$HOME/.cache/theme/alacritty-colors.toml"

[ -f "$THEME_JSON" ] || {
  echo "Theme file not found: $THEME_JSON" >&2
  exit 1
}

mkdir -p "$(dirname "$OUT")"

jq -r '
"[colors.primary]
background = \"" + .special.background + "\"
foreground = \"" + .special.foreground + "\"

[colors.normal]
black   = \"" + .colors.color0 + "\"
red     = \"" + .colors.color1 + "\"
green   = \"" + .colors.color2 + "\"
yellow  = \"" + .colors.color3 + "\"
blue    = \"" + .colors.color4 + "\"
magenta = \"" + .colors.color5 + "\"
cyan    = \"" + .colors.color6 + "\"
white   = \"" + .colors.color7 + "\"

[colors.bright]
black   = \"" + .colors.color8 + "\"
red     = \"" + .colors.color9 + "\"
green   = \"" + .colors.color10 + "\"
yellow  = \"" + .colors.color11 + "\"
blue    = \"" + .colors.color12 + "\"
magenta = \"" + .colors.color13 + "\"
cyan    = \"" + .colors.color14 + "\"
white   = \"" + .colors.color15 + "\"

[colors.selection]
background = \"" + .colors.color4 + "\""
' "$THEME_JSON" > "$OUT"

echo "Alacritty colors generated: $OUT"
