#!/bin/bash

for theme in /usr/share/icons/WhiteSur*; do
    [ -d "$theme" ] || continue

    find "$theme" \
        -type f \
        -name "*-symbolic.svg" \
        ! -name "xsi-*" |
    while read -r file; do
        dir=$(dirname "$file")
        base=$(basename "$file")
        target="$dir/xsi-$base"

        [ -e "$target" ] || ln -s "$base" "$target"
    done

    if [ -f "$theme/index.theme" ]; then
        echo "Updating cache for: $theme"
        gtk-update-icon-cache -f -t "$theme"
    fi
done
