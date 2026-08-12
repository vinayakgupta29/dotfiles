----------------------------------------------------------------------
-- Animation Curves
----------------------------------------------------------------------

hl.curve("easeOutQuint", {
  type = "bezier",
  points = {
    { 0.23, 1 },
    { 0.32, 1 },
  },
})

hl.curve("easeInOutCubic", {
  type = "bezier",
  points = {
    { 0.65, 0.05 },
    { 0.36, 1 },
  },
})

hl.curve("linear", {
  type = "bezier",
  points = {
    { 0, 0 },
    { 1, 1 },
  },
})

hl.curve("almostLinear", {
  type = "bezier",
  points = {
    { 0.5,  0.5 },
    { 0.75, 1 },
  },
})

hl.curve("quick", {
  type = "bezier",
  points = {
    { 0.15, 0 },
    { 0.1,  1 },
  },
})
hl.curve("overshoot", {
  type = "bezier",
  points = {
    { 0.5, 0.9 },
    { 0.1, 1.1 },
  },
})
hl.curve("rubber", {
  type = "spring",
  mass = 1,
  stiffness = 70,
  dampening = 10,
})
hl.curve("genieOut", {
  type = "bezier",
  points = {
    { 0.4, 0.0 },
    { 0.2, 1.0 },
  },
})

hl.curve("workspaceSmooth", {
  type = "bezier",
  points = {
    { 0.25, 0.8 },
    { 0.25, 1.0 },
  },
})
hl.curve("workspaceSnap", {
  type = "bezier",
  points = {
    { 0.4, 0.0 },
    { 0.1, 1.0 },
  },
})
-- Spring curve: quick, soft, with a little bounce
hl.curve("workspaceSpring", { type = "spring", mass = 1, stiffness = 55, dampening = 11 })
----------------------------------------------------------------------
-- Animation Definitions
----------------------------------------------------------------------

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })

hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })

hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "rubber", style = "popin 50%" })

hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.7, bezier = "genieOut", style = "gnomed" })

hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })

hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })

hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })

hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })

hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })

hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade",
})

hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear", })

hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, spring = "workspaceSpring", style = "slidefade 18%" })

hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, spring = "workspaceSpring", style = "slidefade 18%", })

hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, spring = "workspaceSpring", style = "slidefade 18%", })
