-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
-- Declarative object management
local ruled = require("ruled")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- Configuration directory (usually ~/.config/awesome)
local conf_dir = gears.filesystem.get_configuration_dir()

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers. (CHANGEME)
beautiful.init(conf_dir.."themes/nord/theme.lua")

-- Shell commands for statusbar (CHANGEME)
local updates_cmd = "{ timeout 20 checkupdates 2>/dev/null || true; } | wc -l"
local battery_cmd = "cat /sys/class/power_supply/BAT*/capacity"
local ac_cmd = "cat /sys/class/power_supply/ADP*/online"
local brightness_cmd = "cat /sys/class/backlight/*/actual_brightness || echo 0"
local cpu_cmd = "grep -o '^[^ ]*' /proc/loadavg"
local mem_cmd = "free --si -h | awk '/^Mem/ { print $3 }'"
local disk_cmd = "df -h / --output=used | awk 'NR==2{ print $1 }'"
local clock_cmd = "date '+%a %d %b %H:%M:%S'"

-- Statusbar update interval in seconds (CHANGEME)
local statusbar_interval = 1
local updates_interval = 1800

-- This is used later as the default terminal and editor to run. (CHANGEME)
terminal = "kitty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal.." -e "..editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- }}}

-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters. (CHANGEME)
tag.connect_signal("request::default_layouts",
    function()
        awful.layout.append_default_layouts({
            --awful.layout.suit.spiral,
            awful.layout.suit.spiral.dwindle,
            awful.layout.suit.tile,
            --awful.layout.suit.tile.left,
            awful.layout.suit.tile.bottom,
            --awful.layout.suit.tile.top,
            awful.layout.suit.fair,
            awful.layout.suit.fair.horizontal,
            awful.layout.suit.max,
            --awful.layout.suit.max.fullscreen,
            awful.layout.suit.corner.nw,            
            --awful.layout.suit.magnifier,
            --awful.layout.suit.floating,
        })
    end
)
-- }}}

-- {{{ Wibar

-- Keyboard map indicator and switcher
mykeyboardlayout = wibox.container {
    {
        widget = awful.widget.keyboardlayout,
    },
    forced_width = beautiful.kblayout_width,
    widget = wibox.container.place
}

-- Create statusbar widget
mystatusbar = wibox.widget {
    {
        layout = wibox.layout.fixed.horizontal,
        {    -- Updates icon
            {
                {
                    text = beautiful.statusbar_icons[1],
                    widget = wibox.widget.textbox,
                    font = beautiful.statusbar_font,
                },
                left = beautiful.statusbar_spacing,
                right = beautiful.statusbar_spacing,
                widget = wibox.container.margin,
            },
            fg = beautiful.statusbar_colors[1],
            bg = beautiful.statusbar_colors[2],
            widget = wibox.container.background,
        },
        {    -- Updates text
            {
                {
                    id = "updates_text",
                    text = "0",
                    widget = wibox.widget.textbox,
                    font = beautiful.font,
                },
                left = beautiful.statusbar_spacing,
                right = beautiful.statusbar_spacing,
                widget = wibox.container.margin,
            },
            fg = beautiful.statusbar_colors[3],
            bg = beautiful.statusbar_colors[4],
            widget = wibox.container.background,
        },
        {    -- Battery icon
            {
                {
                    id = "battery_icon",
                    widget = wibox.widget.textbox,
                    font = beautiful.statusbar_font,
                },
                left = beautiful.statusbar_spacing,
                right = beautiful.statusbar_spacing,
                widget = wibox.container.margin,   
            },
            fg = beautiful.statusbar_colors[5],
            bg = beautiful.statusbar_colors[6],
            widget = wibox.container.background,
        },
        {    -- Battery text
            {
                {
                    id = "battery_text",
                    widget = wibox.widget.textbox,
                    font = beautiful.font,
                },
                left = beautiful.statusbar_spacing,
                right = beautiful.statusbar_spacing,
                widget = wibox.container.margin,
            },
            fg = beautiful.statusbar_colors[7],
            bg = beautiful.statusbar_colors[8],
            widget = wibox.container.background,
        },
        {    -- Brightness icon
            {
                {
                    id = "brightness_icon",
                    widget = wibox.widget.textbox,
                    font = beautiful.statusbar_font,
                },
                left = beautiful.statusbar_spacing,
                right = beautiful.statusbar_spacing,
                widget = wibox.container.margin,
            },
            fg = beautiful.statusbar_colors[9],
            bg = beautiful.statusbar_colors[10],
            widget = wibox.container.background,
        },
        {    -- Brightness text
            {
                {
                    id = "brightness_text",
                    widget = wibox.widget.textbox,
                    font = beautiful.font,
                },
                left = beautiful.statusbar_spacing,
                right = beautiful.statusbar_spacing,
                widget = wibox.container.margin,
            },
            fg = beautiful.statusbar_colors[11],
            bg = beautiful.statusbar_colors[12],
            widget = wibox.container.background,
        },
        {    -- Cpu icon
            {
                {
                    text = beautiful.statusbar_icons[13],
                    widget = wibox.widget.textbox,
                    font = beautiful.statusbar_font,
                },  
                left = beautiful.statusbar_spacing,
                right = beautiful.statusbar_spacing,
                widget = wibox.container.margin,
            },
            fg = beautiful.statusbar_colors[13],
            bg = beautiful.statusbar_colors[14],
            widget = wibox.container.background,
        },
        {    -- Cpu text
            {
                {
                    id = "cpu_text",
                    widget = wibox.widget.textbox,
                    font = beautiful.font,
                },
                left = beautiful.statusbar_spacing,
                right = beautiful.statusbar_spacing,
                widget = wibox.container.margin,
            },
            fg = beautiful.statusbar_colors[15],
            bg = beautiful.statusbar_colors[16],
            widget = wibox.container.background,
        },
        {    -- Mem icon
            {
                {
                    text = beautiful.statusbar_icons[14],
                    widget = wibox.widget.textbox,
                    font = beautiful.statusbar_font,
                },  
                left = beautiful.statusbar_spacing,
                right = beautiful.statusbar_spacing,
                widget = wibox.container.margin,
            },
            fg = beautiful.statusbar_colors[17],
            bg = beautiful.statusbar_colors[18],
            widget = wibox.container.background,
        },
        {    -- Mem text
            {
                {
                    id = "mem_text",
                    widget = wibox.widget.textbox,
                    font = beautiful.font,
                },
                left = beautiful.statusbar_spacing,
                right = beautiful.statusbar_spacing,
                widget = wibox.container.margin,
            },
            fg = beautiful.statusbar_colors[19],
            bg = beautiful.statusbar_colors[20],
            widget = wibox.container.background,
        },
        {    -- Disk icon
            {
                {
                    text = beautiful.statusbar_icons[15],
                    widget = wibox.widget.textbox,
                    font = beautiful.statusbar_font,
                },  
                left = beautiful.statusbar_spacing,
                right = beautiful.statusbar_spacing,
                widget = wibox.container.margin,
            },
            fg = beautiful.statusbar_colors[21],
            bg = beautiful.statusbar_colors[22],
            widget = wibox.container.background,
        },
        {    -- Disk text
            {
                {
                    id = "disk_text",
                    widget = wibox.widget.textbox,
                    font = beautiful.font,
                },
                left = beautiful.statusbar_spacing,
                right = beautiful.statusbar_spacing,
                widget = wibox.container.margin,
            },
            fg = beautiful.statusbar_colors[23],
            bg = beautiful.statusbar_colors[24],
            widget = wibox.container.background,
        },
        {    -- Clock icon
            {
                {
                    text = beautiful.statusbar_icons[16],
                    widget = wibox.widget.textbox,
                    font = beautiful.statusbar_font,
                },  
                left = beautiful.statusbar_spacing,
                right = beautiful.statusbar_spacing,
                widget = wibox.container.margin,
            },
            fg = beautiful.statusbar_colors[25],
            bg = beautiful.statusbar_colors[26],
            widget = wibox.container.background,
        },
        {    -- Clock text
            {
                {
                    id = "clock_text",
                    widget = wibox.widget.textbox,
                    font = beautiful.font,
                },
                left = beautiful.statusbar_spacing,
                right = beautiful.statusbar_spacing,
                widget = wibox.container.margin,
            },
            fg = beautiful.statusbar_colors[27],
            bg = beautiful.statusbar_colors[28],
            widget = wibox.container.background,
        },
    },
    top = beautiful.statusbar_margin,
    bottom = beautiful.statusbar_margin,
    --left = beautiful.statusbar_margin,
    --right = beautiful.statusbar_margin,
    widget = wibox.container.margin,
}

gears.timer {
    timeout   = statusbar_interval,
    call_now  = true,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async_with_shell(battery_cmd,
            function(bat)
                mystatusbar:get_children_by_id("battery_text")[1]:set_markup_silently(bat)
                awful.spawn.easy_async_with_shell(ac_cmd,
                    function(ac)
                        if ac < "1" then    -- AC is unplugged
                            if bat < "25" then
                                mystatusbar:get_children_by_id("battery_icon")[1]:set_markup_silently(beautiful.statusbar_icons[2])
                            elseif bat < "50" then
                                mystatusbar:get_children_by_id("battery_icon")[1]:set_markup_silently(beautiful.statusbar_icons[3])
                            elseif bat < "75" then
                                mystatusbar:get_children_by_id("battery_icon")[1]:set_markup_silently(beautiful.statusbar_icons[4])
                            else
                                mystatusbar:get_children_by_id("battery_icon")[1]:set_markup_silently(beautiful.statusbar_icons[5])
                            end
                        else
                            if bat < "25" then
                                mystatusbar:get_children_by_id("battery_icon")[1]:set_markup_silently(beautiful.statusbar_icons[6])
                            elseif bat < "50" then
                                mystatusbar:get_children_by_id("battery_icon")[1]:set_markup_silently(beautiful.statusbar_icons[7])
                            elseif bat < "75" then
                                mystatusbar:get_children_by_id("battery_icon")[1]:set_markup_silently(beautiful.statusbar_icons[8])
                            else
                                mystatusbar:get_children_by_id("battery_icon")[1]:set_markup_silently(beautiful.statusbar_icons[9])
                            end
                        end
                    end
                )
            end
        )
        awful.spawn.easy_async_with_shell(brightness_cmd,
            function(out)
                mystatusbar:get_children_by_id("brightness_text")[1]:set_markup_silently(out)
                if out < "33" then
                    mystatusbar:get_children_by_id("brightness_icon")[1]:set_markup_silently(beautiful.statusbar_icons[10])
                elseif out < "66" then
                    mystatusbar:get_children_by_id("brightness_icon")[1]:set_markup_silently(beautiful.statusbar_icons[11])
                else
                    mystatusbar:get_children_by_id("brightness_icon")[1]:set_markup_silently(beautiful.statusbar_icons[12])
                end
            end
        )
        awful.spawn.easy_async_with_shell(cpu_cmd,
            function(out)
                mystatusbar:get_children_by_id("cpu_text")[1]:set_markup_silently(out)
            end
        )
        awful.spawn.easy_async_with_shell(mem_cmd,
            function(out)
                mystatusbar:get_children_by_id("mem_text")[1]:set_markup_silently(out)
            end
        )
        awful.spawn.easy_async_with_shell(disk_cmd,
            function(out)
                mystatusbar:get_children_by_id("disk_text")[1]:set_markup_silently(out)
            end
        )
        awful.spawn.easy_async_with_shell(clock_cmd,
            function(out)
                mystatusbar:get_children_by_id("clock_text")[1]:set_markup_silently(out)
            end
        )
    end
}

gears.timer {
    timeout   = updates_interval,
    call_now  = true,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async_with_shell(updates_cmd,
            function(out)
                mystatusbar:get_children_by_id("updates_text")[1]:set_markup_silently(out)
            end
        )
    end
}

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag(beautiful.tags, s, awful.layout.layouts[1])
    
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = wibox.widget {
        awful.widget.layoutbox {
            screen  = s,
            buttons = {
                awful.button({ }, 1, function () awful.layout.inc( 1) end),
                awful.button({ }, 3, function () awful.layout.inc(-1) end),
                awful.button({ }, 4, function () awful.layout.inc( 1) end),
                awful.button({ }, 5, function () awful.layout.inc(-1) end),
            }
        },
        top = beautiful.layoutbox_margin,
        bottom = beautiful.layoutbox_margin,
        left = beautiful.layoutbox_margin,
        right = beautiful.layoutbox_margin,
        widget = wibox.container.margin
    }

    -- Create tag previews
    if beautiful.tagpreview_enable then
        s.tagpreview_popup = awful.popup {
            preferred_positions = "bottom",
            preferred_anchors = "front",
            offset = { y = beautiful.bar_gap },
            ontop = true,
            widget = wibox.widget.imagebox,
        }
        s.tagpreviews = {}
        s.previous_tags = s.selected_tags
    end

    -- Taglist callback for underline tag colors ang tag preview
    local taglist_callback = function(self, t, index, _)
        if t.selected then    -- Selected tag
            if #t:clients() ~= 0 then
                self:get_children_by_id("background_role")[1].fg = beautiful.tag_colors[t.index]
                self:get_children_by_id("underline")[1].bg = beautiful.tag_colors[t.index]
            else
                self:get_children_by_id("background_role")[1].fg = beautiful.bg_normal
                self:get_children_by_id("underline")[1].bg = beautiful.bg_normal
            end
            beautiful.taglist_fg_focus = self:get_children_by_id("background_role")[1].fg
            if beautiful.tagpreview_enable then
                for _, x in pairs(s.previous_tags) do
                    if #x:clients() ~= 0 then
                        local ss = awful.screenshot {
                            interactive = false,
                            screen = s
                        }
                        ss:refresh()
                        local tagpreview = ss.content_widget
                        tagpreview.forced_height = beautiful.tagpreview_height
                        tagpreview.forced_width = (tagpreview.forced_height)
                                                  * (tagpreview.source_width / tagpreview.source_height)
                        for _, y in pairs(s.previous_tags) do
                            if #y:clients() ~= 0 then
                                s.tagpreviews[y.index] = tagpreview
                            end
                        end
                        break
                    end
                end
                s.previous_tags = s.selected_tags
                collectgarbage("step")    -- Eats up a lot of memory otherwise
            end
            return
        end
        self:get_children_by_id("underline")[1].bg = beautiful.bg_normal -- Unfocused tag
        if #t:clients() ~= 0 then
            self:get_children_by_id("background_role")[1].fg = beautiful.tag_colors[t.index]
        end
    end

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        widget_template = {
            {
                {
                    layout = wibox.layout.stack,
                    {
                        {
                            id = "underline",
                            widget = wibox.container.background,
                        },
                        top = beautiful.bar_height - beautiful.taglist_underline_height,
                        widget = wibox.container.margin,
                    },
                    {
                        {
                            id = "text_role",
                            widget = wibox.widget.textbox,
                        },
                        forced_width = beautiful.taglist_width,
                        widget = wibox.container.place,
                    },
                },
                top = beautiful.taglist_margin_t,
                left = beautiful.taglist_margin_lr,
                right = beautiful.taglist_margin_lr,
                widget = wibox.container.margin,
            },
            id = "background_role",
            widget = wibox.container.background,
            create_callback =
                function(self, t, index, _)
                    taglist_callback(self, t, index, _)
                    if beautiful.tagpreview_enable then
                        self:connect_signal("mouse::enter",
                            function()
                                if not t.selected and #t:clients() ~= 0 then
                                    s.tagpreview_popup.widget = s.tagpreviews[t.index]
                                    s.tagpreview_popup.visible = true
                                end
                            end
                        )
                        self:connect_signal("mouse::leave",
                            function()
                                s.tagpreview_popup.visible = false
                            end
                        )
                    end
                end,
            update_callback = taglist_callback,
        },
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end),
        }
    }

    -- Create a tasklist widget
    s.mytasklist = wibox.widget {
        awful.widget.tasklist {
            screen  = s,
            filter  = awful.widget.tasklist.filter.currenttags,
            buttons = {
                awful.button({ }, 1, function (c)
                    c:activate { context = "tasklist", action = "toggle_minimization" }
                end),
                awful.button({ }, 2, function(c) c:kill() end),
                awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
                awful.button({ }, 4, function() awful.client.focus.byidx( 1) end),
                awful.button({ }, 5, function() awful.client.focus.byidx(-1) end),
            }
        },
        --left = beautiful.tasklist_margin,
        right = beautiful.tasklist_margin,
        top = beautiful.tasklist_margin,
        bottom = beautiful.tasklist_margin,
        widget = wibox.container.margin
    }

    -- Create systray widget
    s.mysystray = wibox.widget {
        {
            {
                base_size = beautiful.systray_icon_size,
                widget = wibox.widget.systray,
            },
            widget = wibox.container.place
        },
        --left = beautiful.systray_margin,
        right = beautiful.systray_margin,
        --top = beautiful.systray_margin,
        --bottom = beautiful.systray_margin,
        widget = wibox.container.margin
    }

    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "top",
        screen   = s,
        height   = beautiful.bar_height,
        widget   = {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                s.mytaglist,
                s.mylayoutbox
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                mystatusbar,
                mykeyboardlayout,
                s.mysystray,
            },
        },
        margins = {    -- Use with theme's "useless_gap'
            top = beautiful.bar_gap,
            left = beautiful.bar_gap,
            right = beautiful.bar_gap
        }
    }

    -- Attach tag previews to wibar
    s.tagpreview_popup:move_next_to(s.mywibox)
    s.tagpreview_popup.visible = false

end)

-- }}}

-- {{{ Mouse bindings

awful.mouse.append_global_mousebindings({
    awful.button({ modkey }, 4, awful.tag.viewnext),
    awful.button({ modkey }, 5, awful.tag.viewprev),
})

-- }}}

-- {{{ Key bindings

-- General Awesome keys (CHANGEME)
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "s"                   , hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey, "Control" }, "r"                   , awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q"                   , awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,           }, "Return"              , function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey            }, "d"                   , function () awful.spawn("rofi -show drun") end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ modkey            }, "w"                   , function () awful.spawn("xdg-open 'about:home'") end,
              {description = "open web browser", group = "launcher"}),
    awful.key({ modkey            }, "f"                   , function () awful.spawn("nemo") end,
              {description = "open file manager", group = "launcher"}),
    awful.key({ modkey            }, "a"                   , function () awful.spawn("gnome-calendar") end,
              {description = "open calendar", group = "launcher"}),
    awful.key({                   }, "Print"               , function () awful.spawn("flameshot gui") end,
              {description = "take screenshot", group = "launcher"}),
    awful.key({ modkey            }, "c"                   , function () awful.spawn("qalculate-gtk") end,
              {description = "open calculator", group = "launcher"}),
    awful.key({ modkey            }, "t"                   , function () awful.spawn("emacs ~/Desktop/misc/todo.org") end,
              {description = "open todo list", group = "launcher"}),
    awful.key({ modkey, "Control" }, "q"                   , function () awful.spawn("shutdown-dialog") end,
              {description = "open shutdown dialog", group = "launcher"}),
    awful.key({                   }, "XF86AudioLowerVolume", function () awful.spawn("pactl set-sink-volume 0 -5%") end,
              {description = "lower volume", group = "media"}),
    awful.key({                   }, "XF86AudioRaiseVolume", function () awful.spawn("pactl set-sink-volume 0 +5%") end,
              {description = "raise volume", group = "media"}),
    awful.key({                   }, "XF86AudioMute"       , function () awful.spawn("pactl set-sink-mute 0 toggle") end,
              {description = "toggle mute", group = "media"}),
    awful.key({                   }, "XF86MonBrightnessUp", function () awful.spawn("xbacklight -inc 5") end,
              {description = "increase brightness", group = "media"}),
    awful.key({                   }, "XF86MonBrightnessDown", function () awful.spawn("xbacklight -dec 5") end,
              {description = "decrease brightness", group = "media"}),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey, "Shift"   }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
                {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),
        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),
        awful.key({ modkey, "Shift"   }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        awful.key({ modkey, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ modkey, "Shift"   }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(un)maximize horizontally", group = "client"}),
    })
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function(c)
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = {  },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- ruled.client.append_rule {
    --     rule       = { class = "Firefox"     },
    --     properties = { screen = 1, tag = "2" }
    -- }
end)
-- }}}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter",
    function(c)
        c:activate { context = "mouse_enter", raise = false }
    end
)

-- Spawn new clients to end of stack (CHANGEME)
client.connect_signal("request::manage",
    function(c)
        if not awesome.startup then
            c:to_secondary_section()
        end
    end
)

-- Change urgent bg color based on (first) tag of client
client.connect_signal("property::urgent",
    function(c)
        if c.urgent and c.first_tag ~= nil then
            beautiful.bg_urgent = beautiful.tag_colors[c.first_tag.index]
        end
    end
)

-- Garbage collector tweaks
collectgarbage("setpause", 140)
collectgarbage("setstepmul", 400)

-- Autostart (CHANGEME)
awful.spawn.single_instance(conf_dir.."autostart.sh")
awful.spawn("nitrogen --restore")
