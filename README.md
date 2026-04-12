## Problem
- Nemo 6+ uses XSI (`xsi-` prefixed symbolic icons)  
- Most icon themes don't provide them fallback to `xapp-symbolic-icons`

## Solution

- Open the terminal with `su` privileges
- Copy the script to the clipboard, paste it into the terminal, and press **Enter**

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
**Or run the nemo-xsi-icon-fix.sh script directly from GitHub**
```
curl -sSL https://raw.githubusercontent.com/AKotov-dev/nemo-xsi-icon-fix/refs/heads/main/nemo-xsi-icon-fix.sh | bash
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
