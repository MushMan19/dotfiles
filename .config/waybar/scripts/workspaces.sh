#!/usr/bin/env bash

# This script outputs JSON for Waybar to display workspaces
# 4 persistent workspaces: 1,2 left of clock; 3,4 right of clock
# Extra workspaces go evenly to left/right

# Get all workspaces from Hyprland
workspaces=$(hyprctl workspaces | awk '{print $2}') # outputs names/numbers

# Persistent workspaces
persistent=(1 2 3 4)

# Arrays to hold left and right sides
left=()
right=()

# Distribute workspaces
for ws in $workspaces; do
    if [[ " ${persistent[*]} " == *" $ws "* ]]; then
        case $ws in
            1|2) left+=("$ws") ;;
            3|4) right+=("$ws") ;;
        esac
    else
        # extra workspaces: alternate left/right
        if (( ${#left[@]} <= ${#right[@]} )); then
            left+=("$ws")
        else
            right+=("$ws")
        fi
    fi
done

# Function to generate JSON
json_array() {
    local arr=("$@")
    local json="["
    for i in "${!arr[@]}"; do
        ws="${arr[i]}"
        json+="{\"text\":\"$ws\",\"tooltip\":\"Workspace $ws\"}"
        if [[ $i -lt $((${#arr[@]}-1)) ]]; then
            json+=","
        fi
    done
    json+="]"
    echo "$json"
}

# Output JSON for Waybar
echo "{\"left\":$(json_array "${left[@]}"),\"right\":$(json_array "${right[@]}")}"
