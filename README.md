# Awesome-Chad
___

## About
*Awesome-Chad* is a complete config for **[Awesome WM](https://awesomewm.org/)** made to look and function like *[chadwm](https://github.com/siduck/chadwm)*. It aims to provide the same user experience as chadwm, while being highly configurable and easily maintainable. The (only) downside is higher memory usage (~ `60MB`, + `10MB` for every tag, if tag previews are enabled).

<img src="https://github.com/MinePro120/awesome-chad/blob/main/media/screenshot.png" width=75%>

### Preview

<video src="https://github.com/MinePro120/awesome-chad/blob/main/media/video.mp4" width=75% controls>
Your browser does not support this video
</video>

### Included color themes
* Nord
* (Contributions welcome!)

## Dependencies
* **awesome** (tested on git version `4.3.1681.g0f950cbb6-1`)
* A patched **[Nerd Font](https://www.nerdfonts.com/)** for the bar icons.
* **rofi** (optional)

## Installation
* Clone the repo:
```
git clone "https://github.com/MinePro120/awesome-chad.git"
```
* Modify the config, as mentioned below.
* Copy the `awesome` folder to your `.config`:
```
cp -r awesome-chad/awesome ~/.config
```
* Log in to awesome or reload it using the appropriate key binding (`Ctrl+Super+r` by default)
* Optionally, install the rofi config as well:
```
cp -r awesome-chad/rofi ~/.config
```

## Configuration
* The sections of `rc.lua` you would probably like to change are marked with `CHANGEME`. These include the theme, key bindings, the commands used by the status bar to fetch system info etc.
* In `themes/<theme>/theme.lua` you can change the colors, fonts, icons, tags, gaps etc.

## Notes
* As mentioned before, tag previews are memory heavy (+ `10MB` for every tag), so there is an option to disable theme in `theme.lua` (`theme.tagpreview_enable`).
* This is my personal config; you are encouraged to modify it locally based on your needs. Only contributions regarding color themes, bug fixes and general improvements will be accepted.
* The default color theme for awesome and rofi is **nord** by default.
* *Picom* is used for the rounded corners in the screenshots.