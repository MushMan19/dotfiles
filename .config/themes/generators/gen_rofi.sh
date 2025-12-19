#!/bin/bash
# gen_rofi.sh
set -eu

THEME_JSON="$1"
ROFI_DIR="$HOME/.cache/theme/rofi_colors"
ROFI_COLORS="$ROFI_DIR/colors.rasi"
ROFI_IMAGE="$ROFI_DIR/rofi_image.png"

[ -f "$THEME_JSON" ] || {
    echo "Theme file not found: $THEME_JSON" >&2
    exit 1
}

mkdir -p "$ROFI_DIR"

# Compute RGB from hex
hexToRgb() {
    hex=${1#*#}
    printf "%d, %d, %d" 0x${hex:0:2} 0x${hex:2:2} 0x${hex:4:2}
}

# Extract main colors
BACKGROUND=$(jq -r '.special.background' "$THEME_JSON")
FOREGROUND=$(jq -r '.special.foreground' "$THEME_JSON")
ACCENT=$(jq -r '.colors.color11' "$THEME_JSON")
SECONDARY=$(jq -r '.colors.color8' "$THEME_JSON")
WALLPAPER=$(jq -r '.wallpaper' "$THEME_JSON")

BG_RGB=$(hexToRgb "$BACKGROUND")

width=$(identify -format "%w" "$WALLPAPER")
height=$(identify -format "%h" "$WALLPAPER")
size=$(( width < height ? width : height ))
magick "$WALLPAPER" -gravity center -crop "${size}x${size}+0+0" +repage "$ROFI_IMAGE"


# Generate valid Rofi color definitions
cat > "$ROFI_COLORS" <<EOF
* {
    background:     $BACKGROUND;
    foreground:     $FOREGROUND;
    accent:         $ACCENT;
    secondary:      $SECONDARY;

    background50: rgba($BG_RGB, 0.5);
    background80: rgba($BG_RGB, 0.8);
}
EOF

echo "Rofi colors generated: $ROFI_COLORS"
echo "Wallpaper copied: $ROFI_IMAGE"
