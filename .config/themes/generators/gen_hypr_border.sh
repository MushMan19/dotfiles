#!/bin/sh
# gen_hypr_border.sh
# Generate Hyprland border color config from theme JSON
set -eu

THEME_JSON="$1"
OUT="$HOME/.cache/theme/hypr_border_colors.conf"

[ -f "$THEME_JSON" ] || {
    echo "Theme file not found: $THEME_JSON" >&2
    exit 1
}

mkdir -p "$(dirname "$OUT")"

# Extract colors and remove leading #
FG=$(jq -r '.special.foreground' "$THEME_JSON" | sed 's/#//')
BG=$(jq -r '.special.background' "$THEME_JSON" | sed 's/#//')

cat > "$OUT" <<EOF
general {
    col.active_border   = rgba(${FG}FF) rgba(${BG}FF) rgba(${BG}FF) rgba(${FG}FF) 90deg
    col.inactive_border = rgba(${BG}FF)
}
EOF

echo "Hyprland border config generated: $OUT"
