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
local primary = "#FFFFFF"
local lightGrayGradient = "0xffa79b8f"
local grayGradient = "0xff504945"
