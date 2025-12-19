#!/bin/sh
# gen_waybar.sh
# Generate Waybar color definitions from theme JSON using @define-color syntax

set -eu

THEME_JSON="$1"
OUT="$HOME/.cache/theme/waybar-colors.css"

[ -f "$THEME_JSON" ] || {
  echo "Theme file not found: $THEME_JSON" >&2
  exit 1
}

mkdir -p "$(dirname "$OUT")"

FG=$(jq -r '.special.foreground' "$THEME_JSON")
BG=$(jq -r '.special.background' "$THEME_JSON")
CURSOR=$(jq -r '.special.cursor // .special.foreground' "$THEME_JSON")

cat > "$OUT" <<EOF
@define-color foreground $FG;
@define-color background $BG;
@define-color cursor $CURSOR;

@define-color color0 $(jq -r '.colors.color0' "$THEME_JSON");
@define-color color1 $(jq -r '.colors.color1' "$THEME_JSON");
@define-color color2 $(jq -r '.colors.color2' "$THEME_JSON");
@define-color color3 $(jq -r '.colors.color3' "$THEME_JSON");
@define-color color4 $(jq -r '.colors.color4' "$THEME_JSON");
@define-color color5 $(jq -r '.colors.color5' "$THEME_JSON");
@define-color color6 $(jq -r '.colors.color6' "$THEME_JSON");
@define-color color7 $(jq -r '.colors.color7' "$THEME_JSON");
@define-color color8 $(jq -r '.colors.color8' "$THEME_JSON");
@define-color color9 $(jq -r '.colors.color9' "$THEME_JSON");
@define-color color10 $(jq -r '.colors.color10' "$THEME_JSON");
@define-color color11 $(jq -r '.colors.color11' "$THEME_JSON");
@define-color color12 $(jq -r '.colors.color12' "$THEME_JSON");
@define-color color13 $(jq -r '.colors.color13' "$THEME_JSON");
@define-color color14 $(jq -r '.colors.color14' "$THEME_JSON");
@define-color color15 $(jq -r '.colors.color15' "$THEME_JSON");
EOF

echo "Waybar colors generated: $OUT"