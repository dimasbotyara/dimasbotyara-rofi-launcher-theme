# 🌸 dimasbotyara-rofi-launcher-theme

Rofi launcher theme pack: **50 color schemes** plus swappable layout styles, with shell scripts to switch either on the fly.

Catppuccin (×4), Dracula, Nord, Gruvbox (×2), Tokyo Night (×3), Everforest, Kanagawa, Rose Pine, Solarized, Night Owl, Monokai, Synthwave84, Vaporwave — and many more.

## Structure

```
launcher.rasi          # the launcher; imports colors/active.rasi + styles/active.rasi
colors/                # 50 color schemes
switch-theme.sh        # switch color scheme
switch-style.sh        # switch layout style
```

## Usage

```bash
./switch-theme.sh catppuccin-mocha
./switch-theme.sh                # no argument → prints available themes
```

`switch-theme.sh` points `colors/active.rasi` at the chosen scheme — rofi picks it up on the next launch.
