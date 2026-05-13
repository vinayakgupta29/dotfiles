-- ~/.config/hypr/execute.lua
-- Converted from execute.conf

----------------------------------------------------------------------
-- Environment variables
----------------------------------------------------------------------

hl.env("HYPRCURSOR_THEME", "Anya_cursor")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Anya_cursor")
hl.env("XCURSOR_SIZE", "24")

hl.env("IBUS_ENABLE_WAYLAND", "1")
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")

-- Override the earlier QT_QPA_PLATFORMTHEME setting in hyprland.lua.
-- This means the effective value will be "qt6ct".
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

----------------------------------------------------------------------
-- Shared variables
----------------------------------------------------------------------

-- This is referenced later by hl.exec_cmd(terminal)
-- Keep this here unless you prefer to define it in a separate variables.lua module.
terminal = "kitty"

----------------------------------------------------------------------
-- Autostart applications and services
----------------------------------------------------------------------
hl.on("hyprland.start", function()
  hl.exec_cmd("fcitx5")

  -- Status bar / shell
  hl.exec_cmd("quickshell -c noctalia-shell")

  -- Welcome sound
  hl.exec_cmd('paplay "$HOME/.local/sounds/custom/DOOM_ Eternal_Welcome_home_great_Slayer.ogg"')

  -- Secret service and authentication agents
  hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=secrets")
  hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
  hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

  -- NetworkManager applet (delayed start)
  hl.exec_cmd('sh -c "sleep 2 && nm-applet --indicator"')

  -- Wallpaper management
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("/home/zoro/.config/hypr/script/wallpaper_slideshow.sh")

  -- Idle daemon
  hl.exec_cmd("hypridle")

  -- Apply cursor theme after startup
  hl.exec_cmd('hyprctl setcursor "Anya_cursor" 24')

  -- Launch terminal automatically
  hl.exec_cmd(terminal)

  ----------------------------------------------------------------------
  -- Theme settings (run every reload, equivalent to `exec =`)
  ----------------------------------------------------------------------

  -- GTK4 / Libadwaita dark mode
  hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')

  -- GTK cursor settings
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'Anya cursor v3'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")

  -- GTK3 theme
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark")
end)
