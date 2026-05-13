-- ~/.config/hypr/hyprwindow_rule.lua
-- Additional window rules converted from hyprwindow_rule.conf

----------------------------------------------------------------------
-- Hyprlock animation
----------------------------------------------------------------------

hl.window_rule({
  name = "window_rule-1",
  animation = "slide",
  match = {
    class = "^(hyprlock)$", },
})

----------------------------------------------------------------------
-- Calculator windows
----------------------------------------------------------------------

-- Matches classes ending in ".Calculator"
hl.window_rule({
  name = "window_rule-2",
  float = true,
  center = true,
  match = {
    class = "^(.*%.Calculator)$",
  },
  size = "400 600",
})

----------------------------------------------------------------------
-- GNOME Calendar
----------------------------------------------------------------------

hl.window_rule({
  name = "window_rule-3",
  float = true,
  size = "300 400",
  move = "((monitor_w*0.752)) ((monitor_h*0.2))",
  match = {
    class = "^org.gnome.Calendar$"
  },
})

----------------------------------------------------------------------
-- xdg-desktop-portal-gtk dialogs
----------------------------------------------------------------------

hl.window_rule({
  name = "window_rule-4",
  float = true,
  size = "900 675",
  match = {
    class = "^(xdg-desktop-portal-gtk)$"
  },
})

----------------------------------------------------------------------
-- Rofi
----------------------------------------------------------------------

hl.window_rule({
  name = "window_rule-5",
  float = true,
  match = {
    class = "^(rofi)$",
  }
})

----------------------------------------------------------------------
-- ProtonVPN
----------------------------------------------------------------------

hl.window_rule({
  name = "window_rule-6",
  size = "400 600",
  match =
  { class = "^(protonvpn-app)$",
  },
})

----------------------------------------------------------------------
-- Android Emulator
----------------------------------------------------------------------

hl.window_rule({
  name = "window_rule-7",
  float = true,
  match = {
    title = "^(.*Android Emulator.*)$",
  },
})

hl.window_rule({
  name = "window_rule-8",
  size = "691 388",
  match = {
    title = "^(Android Emulator.*)$",
  },
})

----------------------------------------------------------------------
-- Foot terminal transparency
----------------------------------------------------------------------

hl.window_rule({
  name = "window_rule-9",
  opacity = "0.65 0.65",
  match = {
    class = "^(foot)$",
  }
})

----------------------------------------------------------------------
-- Mozc candidate window
----------------------------------------------------------------------

hl.window_rule({
  name = "window_rule-10",
  float = true,
  match = {
    class = "^(Mozc)$",
  }
})

----------------------------------------------------------------------
-- Optional Inkscape import dialog (disabled in original config)
----------------------------------------------------------------------

-- hl.window_rule({
--   name = "window_rule-inkscape-import",
--   size = "30 40",
--   float = true,
--   ["match:class"] = "^(inkscape)$",
--   ["match:title"] = "image import",
-- })
