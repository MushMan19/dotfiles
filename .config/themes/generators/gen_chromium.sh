#!/bin/bash
# gen_chromium.sh
# Generate Chromium/Brave theme from JSON palette with proper background/foreground mapping

set -eu

THEME_JSON="$1"
THEME_DIR="$HOME/.cache/theme/chromium_colors"

[ -f "$THEME_JSON" ] || {
    echo "Theme JSON not found: $THEME_JSON" >&2
    exit 1
}

mkdir -p "$THEME_DIR/images"

# Convert hex to "R, G, B"
hexToRgb() {
    plain=${1#*#}
    printf "%d, %d, %d" 0x${plain:0:2} 0x${plain:2:2} 0x${plain:4:2}
}

# Extract colors
BACKGROUND=$(hexToRgb "$(jq -r '.special.background' "$THEME_JSON")")   # main dark background
FOREGROUND=$(hexToRgb "$(jq -r '.special.foreground' "$THEME_JSON")")   # main text color
ACCENT=$(hexToRgb "$(jq -r '.colors.color11' "$THEME_JSON")")           # accent color
SECONDARY=$(hexToRgb "$(jq -r '.colors.color8' "$THEME_JSON")")          # secondary/inactive

WALLPAPER=$(jq -r '.wallpaper' "$THEME_JSON")

# Copy wallpaper
BACKGROUND_IMAGE="images/theme_ntp_background_norepeat.png"
cp "$WALLPAPER" "$THEME_DIR/$BACKGROUND_IMAGE"

# Generate manifest.json with proper mapping
cat > "$THEME_DIR/manifest.json" <<EOF
{
  "manifest_version": 3,
  "version": "1.0",
  "name": "Chromium Theme",
  "theme": {
    "images": {
      "theme_ntp_background": "$BACKGROUND_IMAGE"
    },
    "colors": {
      "frame": [$BACKGROUND],
      "frame_inactive": [$SECONDARY],
      "frame_incognito": [$BACKGROUND],
      "frame_incognito_inactive": [$SECONDARY],

      "toolbar": [$BACKGROUND],
      "toolbar_incognito": [$BACKGROUND],
      "toolbar_text": [$FOREGROUND],
      "toolbar_button_icon": [$FOREGROUND],
      "toolbar_button_icon_incognito": [$FOREGROUND],

      "omnibox_background": [$BACKGROUND],
      "omnibox_background_incognito": [$SECONDARY],
      "omnibox_text": [$FOREGROUND],
      "omnibox_text_incognito": [$FOREGROUND],

      "ntp_text": [$FOREGROUND],
      "ntp_link": [$ACCENT],
      "ntp_section": [$BACKGROUND],

      "button_background": [$BACKGROUND],

      "tab_background_text": [$FOREGROUND],
      "tab_background_text_incognito": [$FOREGROUND],

      "bookmark_text": [$FOREGROUND],
      "bookmark_text_incognito": [$FOREGROUND]
    },
    "properties": {
      "ntp_background_alignment": "center",
      "ntp_background_repeat": "no-repeat"
    }
  }
}
EOF

echo "Chromium theme generated: $THEME_DIR"
