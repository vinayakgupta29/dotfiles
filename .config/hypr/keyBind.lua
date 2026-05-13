-- ~/.config/hypr/keyBind.lua
-- Converted from keyBind.conf

----------------------------------------------------------------------
-- Program definitions
-- These are global so exec_cmdute.lua and other modules can reuse them.
----------------------------------------------------------------------

terminal = "kitty"
fileManager = "dolphin"
browser = "firefox"

reboot = 'notify-send "Rebooting..." && sleep 3 && reboot'
shutdown = [[sh -c 'notify-send "Shutting down..." ; (sleep 1; systemctl poweroff) &']]

menu = "rofi -show drun -theme ~/.config/rofi/style.rasi"
nmtui = [[kitty --title KittyNmtui -e sh -c 'sleep 0.1; nmtui']]
powermenu = [[bash -c '$HOME/.config/waybar/scripts/powermenu.sh']]
lang_toggle = [[bash -c '$HOME/.config/waybar/scripts/ibus-toggle.sh']]

mainMod = "SUPER"

monitor_d = "DP-1"
----------------------------------------------------------------------
-- Core keybindings
----------------------------------------------------------------------

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
-- hl.bind(mainMod .. " + SHIFT + F", hl.dsp.togglefloating())
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("resizewindow"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
--hl.bind(mainMod .. " + J", hl.dsp.window.togglesplit())
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("sudo systemctl restart sddm"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("pkill rofi || " .. menu))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(reboot))
hl.bind(mainMod .. " + END", hl.dsp.exec_cmd(shutdown))
hl.bind(mainMod .. " + COMMA", hl.dsp.exec_cmd("emote"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

----------------------------------------------------------------------
-- Focus movement
----------------------------------------------------------------------

hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + UP", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + DOWN", hl.dsp.focus({ direction = "d" }))
----------------------------------------------------------------------
-- Switch to workspace
----------------------------------------------------------------------

for i = 1, 9 do
  hl.bind(
    mainMod .. " + " .. i,
    hl.dsp.focus({ workspace = tostring(i) })
  )
end

hl.bind(
  mainMod .. " + 0",
  hl.dsp.focus({ workspace = "10" })
)

----------------------------------------------------------------------
-- Move active window to workspace
----------------------------------------------------------------------

for i = 1, 9 do
  hl.bind(
    mainMod .. " + SHIFT + " .. i,
    hl.dsp.window.move({
      workspace = tostring(i),
      monitor = monitor_d,
    })
  )
end

hl.bind(
  mainMod .. " + SHIFT + 0",
  hl.dsp.window.move({ workspace = "10", monitor = monitor_d,
  })
)
----------------------------------------------------------------------
-- Special workspace (scratchpad)
----------------------------------------------------------------------

hl.bind(mainMod .. " + S",
  hl.dsp.workspace.toggle_special("magic"))

hl.bind(mainMod .. " + SHIFT + S",
  hl.dsp.workspace.move({ workspace = "special:magic", monitor = monitor_d,
  }))

----------------------------------------------------------------------
-- Workspace scrolling
----------------------------------------------------------------------

hl.bind(mainMod .. " + mouse_down",
  hl.dsp.workspace.move({ workspace = "e+1", monitor = monitor_d,
  }))

hl.bind(mainMod .. " + mouse_up",
  hl.dsp.workspace.move({ workspace = "e-1", monitor = monitor_d,
  }))

----------------------------------------------------------------------
-- Mouse binds
----------------------------------------------------------------------

hl.bind(
  mainMod .. " + mouse:272",
  hl.dsp.window.drag(),
  { mouse = true }
)

hl.bind(
  mainMod .. " + mouse:273",
  hl.dsp.window.resize(),
  { mouse = true }
)

----------------------------------------------------------------------
-- Bind option presets
----------------------------------------------------------------------

local locked = {
  locked = true,
}

local repeat_locked = {
  repeating = true,
  locked = true,
}

----------------------------------------------------------------------
-- Multimedia and brightness keys (equivalent to bindel)
----------------------------------------------------------------------

hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  repeat_locked
)

hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  repeat_locked
)

hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  repeat_locked
)

hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  repeat_locked
)

hl.bind(
  "XF86MonBrightnessUp",
  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
  repeat_locked
)

hl.bind(
  "XF86MonBrightnessDown",
  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
  repeat_locked
)

----------------------------------------------------------------------
-- Media control keys (equivalent to bindl)
----------------------------------------------------------------------

hl.bind(
  "XF86AudioNext",
  hl.dsp.exec_cmd("playerctl next"),
  locked
)

hl.bind(
  "XF86AudioPause",
  hl.dsp.exec_cmd("playerctl play-pause"),
  locked
)

hl.bind(
  "XF86AudioPlay",
  hl.dsp.exec_cmd("playerctl play-pause"),
  locked
)

hl.bind(
  "XF86AudioPrev",
  hl.dsp.exec_cmd("playerctl previous"),
  locked
)
----------------------------------------------------------------------
-- Screenshots
----------------------------------------------------------------------

hl.bind("Print", hl.dsp.exec_cmd(
  [[sh -c 'hyprshot -m window -o "$HOME/Pictures/Screenshots" ; paplay "/usr/share/sounds/freedesktop/stereo/screen-capture.oga"']]
))

hl.bind("SHIFT + Print", hl.dsp.exec_cmd(
  "hyprshot -m region -o $HOME/Pictures/Screenshots"
))

hl.bind("ALT + Print", hl.dsp.exec_cmd(
  "hyprshot -m output -o $HOME/Pictures/Screenshots"
))

----------------------------------------------------------------------
-- Custom bindings
----------------------------------------------------------------------

hl.bind("CTRL + ALT + DELETE",
  hl.dsp.exec_cmd("missioncenter"))

hl.bind(mainMod .. " + W",
  hl.dsp.exec_cmd(nmtui))

hl.bind(mainMod .. " + ALT + P",
  hl.dsp.exec_cmd(powermenu))

hl.bind(mainMod .. " + SPACE",
  hl.dsp.exec_cmd(lang_toggle))
