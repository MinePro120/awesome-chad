--------------------------------------
-- Nord awesome theme by MinePro120 --
--------------------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi  -- Requires .Xresources file with set dpi
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local conf_dir = gfs.get_configuration_dir()
local theme = {}


-- Fonts
theme.font           = "Noto Sans Medium 11"
theme.taglist_font   = "SauceCodePro NFM 18"
theme.statusbar_font = "SauceCodePro NFM 16"


-- Nord colors
local nord = {}
nord.polar = { "#2e3440", "#3b4252", "#434c5e", "#4c566a" }
nord.snow = { "#d8dee9", "#e5e9f0", "#eceff4" }
nord.frost = { "#8fbcbb", "#88c0d0", "#81a1c1", "#5e81ac" }
nord.aurora = { "#bf616a", "#d08770", "#ebcb8b", "#a3be8c", "#b48ead" }


-- Global colors
theme.bg_normal     = nord.polar[1]
theme.bg_focus      = nord.polar[4]
theme.bg_urgent     = nord.aurora[1]
theme.bg_minimize   = nord.polar[2]
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = nord.snow[2]
theme.fg_focus      = nord.snow[3]
theme.fg_urgent     = theme.bg_normal
theme.fg_minimize   = nord.snow[1]


-- Statusbar
theme.statusbar_colors = {
--  Icon fg         Icon bg          Text fg          Text bg
    nord.aurora[4], theme.bg_normal, nord.aurora[4] , theme.bg_normal,  -- upd
    nord.frost[3] , theme.bg_normal, nord.frost[3]  , theme.bg_normal,  -- bat
    nord.aurora[2], theme.bg_normal, nord.aurora[2] , theme.bg_normal,  -- brt
    nord.polar[2] , nord.aurora[4] , theme.fg_normal, nord.polar[3],    -- cpu
    nord.frost[3] , nord.polar[2]  , nord.frost[3]  , nord.polar[2],    -- mem
    nord.aurora[2], nord.polar[2]  , nord.aurora[2] , nord.polar[2],    -- dsk
    nord.polar[2] , nord.frost[4]  , nord.polar[2]  , nord.frost[3],    -- clk
}
theme.statusbar_icons = {
    "󰚰",                                     -- upd
    "󰂎", "󱊡", "󱊢", "󱊣", "󰢟", "󱊤", "󱊥", "󱊦",  -- bat
    "󰃞", "󰃟", "󰃠",                           -- brt
    "󰻠",                                     -- cpu
    "󰍛",                                     -- mem     
    "󰋊",                                     -- dsk
    "󰥔"                                      -- clk
}

-- These are other variable sets overriding the above defaults when defined:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]


-- Bar settings
theme.bar_height = dpi(27.5)


-- Tags
theme.tags = { "", "", "", "", "", "", "", "" }
theme.tag_colors = {
    nord.frost[3],
    nord.aurora[3],
    nord.aurora[4],
    nord.aurora[2],
    nord.aurora[1],
    nord.frost[2],
    nord.aurora[5],
    nord.frost[4],
}


-- Taglist
theme.taglist_margin_t = 0
theme.taglist_margin_lr = dpi(3)
theme.taglist_width = dpi(27)
theme.taglist_underline_height = dpi(2)

theme.taglist_fg_empty = nord.polar[4]
--theme.taglist_bg_focus = theme.bg_normal


-- Tag preview
-- Preview each tag by hovering the mouse over the taglist
-- It is quite memory heavy (e.g. +10 MB per tag), so here's
-- an option to disable it
theme.tagpreview_enable = true
theme.tagpreview_height = dpi(150)


-- Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(20)
theme.menu_width  = dpi(100)


-- Systray
theme.systray_icon_spacing = dpi(3)
theme.systray_icon_size = 24
theme.systray_margin = dpi(3)


-- Gaps and margins
theme.useless_gap       = dpi(1.5)
theme.bar_gap           = dpi(3)

theme.tasklist_margin   = dpi(3)
theme.tasklist_spacing  = dpi(1.5)

theme.layoutbox_margin  = dpi(6)

theme.statusbar_margin  = dpi(3)
theme.statusbar_spacing = dpi(4)

theme.kblayout_width    = dpi(25)


-- Window borders
theme.border_width = 0
--theme.border_color_normal = "#000000"
--theme.border_color_active = "#535d6c"
--theme.border_color_marked = "#91231c"


-- Layout icons
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"


-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
