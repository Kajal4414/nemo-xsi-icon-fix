#!/bin/bash

for theme in /usr/share/icons/*; do
    [ -d "$theme" ] || continue

    find "$theme" -type f -name "*-symbolic.svg" | while read file; do
        dir=$(dirname "$file")
        base=$(basename "$file")
        target="$dir/xsi-$base"

        if [ ! -e "$target" ]; then
            ln -s "$base" "$target"
        fi
    done

    # Проверка на index.theme
    if [ -f "$theme/index.theme" ]; then
        echo "Updating cache for: $theme"
        gtk-update-icon-cache -f -t "$theme"
    fi
done

