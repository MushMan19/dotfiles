#!/bin/bash
set -eu

THEME_JSON="$1"
OUT_DIR="$HOME/.cache/theme"
OUT_FILE="$OUT_DIR/gtk3_colors.css"

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
BG_50=$(hex_to_rgba "$BACKGROUND" 0.5)

# ---- Generate CSS ----
cat > "$OUT_FILE" <<EOF
@define-color gtk_fg $FG_RGB;
@define-color gtk_fg_20 $FG_20;
@define-color gtk_bg_50 $BG_50;
EOF

echo "GTK3 colors generated: $OUT_FILE"