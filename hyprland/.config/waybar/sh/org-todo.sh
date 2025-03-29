#!/usr/bin/env bash
#!/bin/bash
FILE=~/.emacs.d/remember.org

# Ensure the file exists
[ -f "$FILE" ] || { printf '{"text": "0 TODO", "tooltip": "No TODOs"}\n'; exit 0; }

# Count TODOs (match * TODO, ** TODO, *** TODO, etc.)
COUNT=$(grep -E -c '^\*+ TODO' "$FILE")

# Extract TODO lines for tooltip
TODOS=$(grep -E '^\*+ TODO' "$FILE" | sed -z 's/\n/\\n/g')

# If COUNT is zero, set tooltip to "No TODOs"
[ "$COUNT" -eq 0 ] && TODOS="No TODOs"

# Output JSON for Waybar with "TODO" (not "todos")
printf '{"text": "%s TODO", "tooltip": "%s"}\n' "$COUNT" "$TODOS"
