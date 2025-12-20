#!/bin/bash
# gen_gtk.sh
# Generate GTK color overrides for your dark-blue theme from wal JSON

set -eu

[[ $# -eq 1 ]] || { echo "Usage: $0 theme.json"; exit 1; }

THEME_JSON="$1"
GTK_CACHE_DIR="$HOME/.cache/theme"
mkdir -p "$GTK_CACHE_DIR"

GTK_FILE="$GTK_CACHE_DIR/gtk_colors.css"

# Extract main colors from JSON (you can add more if needed)
BACKGROUND=$(jq -r '.special.background' "$THEME_JSON")
FOREGROUND=$(jq -r '.special.foreground' "$THEME_JSON")
ACCENT=$(jq -r '.colors.color11' "$THEME_JSON")
SECONDARY=$(jq -r '.colors.color8' "$THEME_JSON")

# Helper: hex to rgba (preserve transparency if provided)
hex_to_rgba() {
    local hex=${1#"#"}
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    local a=${2:-1}
    echo "rgba($r, $g, $b, $a)"
}

# Generate gtk_colors.css
cat > "$GTK_FILE" << EOF
/* GTK NAMED COLORS */
@define-color theme_fg_color_breeze $(hex_to_rgba "$FOREGROUND");
@define-color theme_text_color_breeze $(hex_to_rgba "$FOREGROUND");
@define-color theme_bg_color_breeze $(hex_to_rgba "$BACKGROUND" 0.5);
@define-color theme_base_color_breeze $(hex_to_rgba "$SECONDARY");
@define-color theme_view_hover_decoration_color_breeze $(hex_to_rgba "$BACKGROUND" 1);
@define-color theme_hovering_selected_bg_color_breeze $(hex_to_rgba "$ACCENT");
@define-color theme_selected_bg_color_breeze $(hex_to_rgba "$ACCENT");
@define-color theme_selected_fg_color_breeze $(hex_to_rgba "$FOREGROUND");
@define-color theme_view_active_decoration_color_breeze $(hex_to_rgba "$ACCENT");
@define-color insensitive_selected_bg_color_breeze $(hex_to_rgba "$ACCENT" 0.35);
@define-color insensitive_bg_color_breeze $(hex_to_rgba "$SECONDARY");
@define-color insensitive_fg_color_breeze $(hex_to_rgba "$FOREGROUND" 0.35);
@define-color insensitive_base_color_breeze $(hex_to_rgba "$FOREGROUND" 0.35);
@define-color insensitive_base_fg_color_breeze $(hex_to_rgba "$SECONDARY");
@define-color insensitive_selected_fg_color_breeze $(hex_to_rgba "$FOREGROUND" 0.35);
@define-color theme_unfocused_fg_color_breeze $(hex_to_rgba "$FOREGROUND");
@define-color theme_unfocused_text_color_breeze $(hex_to_rgba "$FOREGROUND");
@define-color theme_unfocused_bg_color_breeze $(hex_to_rgba "$BACKGROUND" 0.5);
@define-color theme_unfocused_base_color_breeze $(hex_to_rgba "$SECONDARY");
@define-color theme_unfocused_selected_bg_color_alt_breeze $(hex_to_rgba "$ACCENT");
@define-color theme_unfocused_selected_bg_color_breeze $(hex_to_rgba "$ACCENT" 0.5);
@define-color theme_unfocused_selected_fg_color_breeze $(hex_to_rgba "$FOREGROUND");
@define-color insensitive_unfocused_selected_bg_color_breeze $(hex_to_rgba "$ACCENT" 0.35);
@define-color insensitive_unfocused_fg_color_breeze $(hex_to_rgba "$FOREGROUND" 0.35);
@define-color insensitive_unfocused_bg_color_breeze $(hex_to_rgba "$SECONDARY");
@define-color insensitive_unfocused_selected_fg_color_breeze $(hex_to_rgba "$FOREGROUND" 0.35);
@define-color theme_unfocused_view_text_color_breeze $(hex_to_rgba "$FOREGROUND" 0.35);
@define-color theme_unfocused_view_bg_color_breeze $(hex_to_rgba "$SECONDARY");
@define-color borders_breeze $(hex_to_rgba "$ACCENT");
@define-color unfocused_borders_breeze $(hex_to_rgba "$ACCENT");
@define-color insensitive_borders_breeze $(hex_to_rgba "$ACCENT" 0.35);
@define-color unfocused_insensitive_borders_breeze $(hex_to_rgba "$ACCENT" 0.35);
@define-color theme_button_background_normal_breeze $(hex_to_rgba "$SECONDARY");
@define-color theme_button_decoration_hover_breeze $(hex_to_rgba "$ACCENT");
@define-color theme_button_decoration_focus_breeze $(hex_to_rgba "$ACCENT");
@define-color theme_button_foreground_normal_breeze $(hex_to_rgba "$FOREGROUND");
@define-color theme_button_foreground_active_breeze $(hex_to_rgba "$FOREGROUND");
@define-color theme_button_background_insensitive_breeze $(hex_to_rgba "$SECONDARY" 0.35);
@define-color theme_button_decoration_hover_insensitive_breeze $(hex_to_rgba "$ACCENT" 0.35);
@define-color theme_button_decoration_focus_insensitive_breeze $(hex_to_rgba "$ACCENT" 0.35);
@define-color theme_button_foreground_insensitive_breeze $(hex_to_rgba "$FOREGROUND" 0.35);
@define-color theme_button_foreground_active_insensitive_breeze $(hex_to_rgba "$FOREGROUND" 0.35);
@define-color theme_button_background_backdrop_breeze $(hex_to_rgba "$SECONDARY");
@define-color theme_button_decoration_hover_backdrop_breeze $(hex_to_rgba "$ACCENT");
@define-color theme_button_decoration_focus_backdrop_breeze $(hex_to_rgba "$ACCENT");
@define-color theme_button_foreground_backdrop_breeze $(hex_to_rgba "$FOREGROUND");
@define-color theme_button_foreground_active_backdrop_breeze $(hex_to_rgba "$FOREGROUND");
@define-color theme_button_background_backdrop_insensitive_breeze $(hex_to_rgba "$SECONDARY" 0.35);
@define-color theme_button_decoration_hover_backdrop_insensitive_breeze $(hex_to_rgba "$ACCENT" 0.35);
@define-color theme_button_decoration_focus_backdrop_insensitive_breeze $(hex_to_rgba "$ACCENT" 0.35);
@define-color theme_button_foreground_backdrop_insensitive_breeze $(hex_to_rgba "$FOREGROUND" 0.35);
@define-color theme_button_foreground_active_backdrop_insensitive_breeze $(hex_to_rgba "$FOREGROUND" 0.35);
@define-color warning_color_breeze $(hex_to_rgba "$BACKGROUND" 1);
@define-color error_color_breeze #da4453;
@define-color success_color_breeze #27ae60;
@define-color warning_color_backdrop_breeze $(hex_to_rgba "$BACKGROUND" 1);
@define-color error_color_backdrop_breeze #da4453;
@define-color success_color_backdrop_breeze #27ae60;
@define-color warning_color_insensitive_breeze $(hex_to_rgba "$BACKGROUND" 0.5);
@define-color error_color_insensitive_breeze $(hex_to_rgba "$BACKGROUND" 0.5);
@define-color success_color_insensitive_breeze $(hex_to_rgba "$ACCENT" 0.35);
@define-color warning_color_insensitive_backdrop_breeze $(hex_to_rgba "$BACKGROUND" 0.5);
@define-color error_color_insensitive_backdrop_breeze $(hex_to_rgba "$BACKGROUND" 0.5);
@define-color success_color_insensitive_backdrop_breeze $(hex_to_rgba "$ACCENT" 0.35);
@define-color link_color_breeze $(hex_to_rgba "$ACCENT");
@define-color link_visited_color_breeze #9b59b6;
@define-color theme_titlebar_background_breeze $(hex_to_rgba "$SECONDARY");
@define-color theme_titlebar_foreground_breeze $(hex_to_rgba "$FOREGROUND");
@define-color theme_titlebar_background_light_breeze $(hex_to_rgba "$SECONDARY");
@define-color theme_titlebar_foreground_backdrop_breeze $(hex_to_rgba "$ACCENT");
@define-color theme_titlebar_background_backdrop_breeze $(hex_to_rgba "$SECONDARY");
@define-color theme_titlebar_foreground_insensitive_breeze $(hex_to_rgba "$FOREGROUND" 0.35);
@define-color theme_titlebar_foreground_insensitive_backdrop_breeze $(hex_to_rgba "$ACCENT" 0.35);
@define-color tooltip_text_breeze $(hex_to_rgba "$FOREGROUND");
@define-color tooltip_background_breeze $(hex_to_rgba "$SECONDARY");
@define-color tooltip_border_breeze $(hex_to_rgba "$ACCENT");
@define-color print_paper_backdrop_breeze white;
@define-color content_view_bg_breeze $(hex_to_rgba "$SECONDARY");

/* GTK API color re-defs */
@define-color theme_fg_color @theme_fg_color_breeze;
@define-color theme_text_color @theme_text_color_breeze;
@define-color theme_bg_color @theme_bg_color_breeze;
@define-color theme_base_color @theme_base_color_breeze;
@define-color theme_selected_bg_color @theme_selected_bg_color_breeze;
@define-color theme_selected_fg_color @theme_selected_fg_color_breeze;
@define-color insensitive_bg_color @insensitive_bg_color_breeze;
@define-color insensitive_fg_color @insensitive_fg_color_breeze;
@define-color insensitive_base_color @insensitive_base_color_breeze;
@define-color theme_unfocused_fg_color @theme_unfocused_fg_color_breeze;
@define-color theme_unfocused_text_color @theme_unfocused_text_color_breeze;
@define-color theme_unfocused_bg_color @theme_unfocused_bg_color_breeze;
@define-color theme_unfocused_base_color @theme_unfocused_base_color_breeze;
@define-color theme_unfocused_selected_bg_color @theme_unfocused_selected_bg_color_breeze;
@define-color theme_unfocused_selected_fg_color @theme_unfocused_selected_fg_color_breeze;
@define-color unfocused_insensitive_color @unfocused_insensitive_color_breeze;
@define-color borders @borders_breeze;
@define-color unfocused_borders @unfocused_borders_breeze;
@define-color warning_color @warning_color_breeze;
@define-color error_color @error_color_breeze;
@define-color success_color @success_color_breeze;
@define-color content_view_bg @content_view_bg_breeze;

EOF

echo "GTK colors generated at $GTK_FILE"
