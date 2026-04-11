## Problem
Nemo 6+ uses XSI (`xsi-` prefixed symbolic icons).  
Most icon themes don't provide them fallback to `xapp-symbolic-icons`.

## Disclaimer

This script modifies icon themes by creating symbolic links and updating icon caches.

- Run it at your own risk
- It requires root privileges
- It affects all icon themes in `/usr/share/icons`

The script is safe in normal conditions:
- it does not overwrite existing files
- it only creates missing `xsi-*` symlinks

However, it is recommended to:
- test on a non-production system first
- or use the single-theme variant if unsure

## Solution
Create xsi-* symlinks automatically for any theme.

- Open the terminal with `su` privileges.
- Copy the script to the clipboard, paste it into the terminal, and press **Enter**.

### All icon themes will be processed: `/usr/share/icons/*`

```
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
```
  
### A script variant for selected icon theme
cd /usr/share/icons/`THEME_NAME`
```
find . -type f -name "*-symbolic.svg" | while read file; do
    dir=$(dirname "$file")
    base=$(basename "$file")
    target="$dir/xsi-$base"
    [ -e "$target" ] || ln -s "$base" "$target"
done

gtk-update-icon-cache -f -t ./
```
**If something breaks — you get to keep both pieces :)**
