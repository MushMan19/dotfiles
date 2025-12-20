#!/bin/bash
set -eu

THEME_JSON="$1"
OUT_DIR="$HOME/.cache/theme"
OUT_FILE="$OUT_DIR/swayosd_colors.css"

mkdir -p "$OUT_DIR"

# ---- Extract colors ----
FOREGROUND=$(jq -r '.special.foreground' "$THEME_JSON")
BACKGROUND=$(jq -r '.special.background' "$THEME_JSON")

# ---- Helpers ----
hex_to_rgba() {
    local hex="${1#"#"}"
    local a="${2:-1.0}"
    printf "rgba(%d,%d,%d,%s)" \
        "0x${hex:0:2}" \
        "0x${hex:2:2}" \
        "0x${hex:4:2}" \
        "$a"
}

FG_RGB=$(hex_to_rgba "$FOREGROUND" 1.0)
FG_20=$(hex_to_rgba "$FOREGROUND" 0.2)
BG_70=$(hex_to_rgba "$BACKGROUND" 0.7)

# ---- Generate CSS ----
cat > "$OUT_FILE" <<EOF
@define-color osd_fg $FG_RGB;
@define-color osd_fg_20 $FG_20;
@define-color osd_bg_70 $BG_70;
EOF

echo "SwayOSD colors generated: $OUT_FILE"