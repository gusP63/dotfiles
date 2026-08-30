-- Programs
local terminal = "foot"
local fileManager = "nautilus"
local menu = "rofi"
local lockscreen = "hyprlock"
local colorpicker = "hyprpicker"
local screenshot = "hyprshot"
local cursor = "Bibata-Original-Classic 24"

-- Envs
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Autostart
hl.on("hyprland.start", function()
        hl.exec_cmd("xrandr --output DP-1 --primary")
        hl.exec_cmd("eval $(ssh-agent -s);")
        hl.exec_cmd("hyprpaper")
        hl.exec_cmd("hyprsunset")
        hl.exec_cmd("systemctl --user start hyprpolkitagent")
        hl.exec_cmd("wl-paste --watch cliphist store")
        hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
        hl.exec_cmd("hyprctl setcursor " .. cursor)
        hl.exec_cmd("waybar")
        hl.exec_cmd("pianoterm -n Roland -c ~/.config/pianoterm/config_playback")
        hl.exec_cmd("pianoterm -n LPD8 -c ~/.config/pianoterm/config_pad")
        hl.exec_cmd(
                "kiwix-serve -d -p 1024 $MEDIA/Kiwix/wikipedia_en_all_maxi_2026-02.zim $MEDIA/Kiwix/archlinux_en_all_maxi_2025-09.zim")
        hl.exec_cmd("hyprpm reload")
end)


-- Theme
-- local primary = "#FFFFFF"
-- local lightGrayGradient = "0xffa79b8f"
-- local grayGradient = "0xff504945"

hl.config({
        general = {
                layout = "scrolling",
                gaps_in = 2,
                gaps_out = 2,
                border_size = 0,
        },

        scrolling = {
                fullscreen_on_one_column = true,
                column_width = 1.0,
        },

        decoration = {
                rounding = 1,
                active_opacity = 1.0,
                inactive_opacity = 1.0,
                blur = {
                        enabled = false,
                },
        },

        cursor = {
                inactive_timeout = 30,
                no_hardware_cursors = 1,
        },

        misc = {
                font_family = "Ioskeley Mono",
                disable_hyprland_logo = true,
        },

        binds = {
                workspace_center_on = 1,
        },

        input = {
                kb_layout = "pt",
                kb_model = "pc105",
                kb_variant = "nodeadkeys",
                repeat_rate = 20,
                repeat_delay = 200,
                follow_mouse = 1,
                tablet = {
                        relative_input = false,
                },
        },

        plugin = {
                hypr_autoscroll = {
                        enabled = true,
                        sensitivity = 1,
                        dead_zone = 5,
                        button = 276,
                },
        },
})

-- smart gaps
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })

local mainMod = "SUPER"
local left = "h"
local down = "j"
local up = "k"
local right = "l"

-- programs
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("rofi -show drun -hint-welcome ''"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + CONTROL + Q", hl.dsp.exec_cmd(lockscreen))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("rofi -modi 'window' -show window"))
hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd("rofimoji --clipboarder wl-copy"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(colorpicker))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(screenshot .. "-m region"))

-- windows
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind(mainMod .. " + " .. left, hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + " .. right, hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + " .. up, hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + " .. down, hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + " .. left, hl.dsp.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + " .. right, hl.dsp.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + " .. up, hl.dsp.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + " .. down, hl.dsp.move({ direction = "down" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- workspaces [0-9]
for i = 1, 10 do
        local key = i % 10 -- 10 maps to key 0
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
        { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ 5%-"),
        { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
        { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SOURCE@ toggle"),
        { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
