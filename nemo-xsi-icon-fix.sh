#!/bin/bash

set -euo pipefail

XSI_SOURCE="/usr/share/icons/hicolor/scalable/actions"

[ -d "$XSI_SOURCE" ] || {
    echo "XSI source directory not found: $XSI_SOURCE"
    exit 1
}

for theme in /usr/share/icons/WhiteSur*; do
    [ -d "$theme" ] || continue

    echo "Processing: $(basename "$theme")"

    while IFS= read -r -d '' xsi_file; do
        xsi_base=$(basename "$xsi_file")

        target="${theme}/actions/symbolic/${xsi_base}"

        # Skip if theme already provides this icon
        [ -e "$target" ] && continue

        base_icon="${xsi_base#xsi-}"

        # Use existing WhiteSur icon if available
        if [ -f "${theme}/actions/symbolic/${base_icon}" ]; then
            ln -s "${base_icon}" "$target"
            echo "  + ${xsi_base} -> ${base_icon}"
        fi
    done < <(find "$XSI_SOURCE" -type f -name 'xsi-*.svg' -print0)

    if [ -f "$theme/index.theme" ]; then
        echo "Updating cache for: $(basename "$theme")"
        gtk-update-icon-cache -f -t "$theme"
    fi
done
