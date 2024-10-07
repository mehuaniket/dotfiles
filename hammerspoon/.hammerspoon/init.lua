-- Hammerspoon Configuration
hs = hs or {}
-- Global variables
local hyper = { "ctrl", "alt", "cmd" }

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall:andUse("WindowHalfsAndThirds", {
	hotkeys = "default",
})

-- Load the MoveWindowBetweenScreens spoon
hs.loadSpoon("MoveWindowBetweenScreens")

-- Set up hotkeys
spoon.MoveWindowBetweenScreens:bindHotkeys({
	moveWindowToNextDisplay = { hyper, "right" },
	moveWindowToPreviousDisplay = { hyper, "left" },
})

-- Use SpoonInstall to install MouseFollowsFocus Spoon
spoon.SpoonInstall:andUse("MouseFollowsFocus", {
	repo = "default", -- This will look for the spoon in the default repository
	start = true, -- Automatically start the spoon after installation
})

-- Load external hotkeys file
require("hotkeys")

-- Reload Hammerspoon configuration
hs.alert.show("Hammerspoon config loaded")
