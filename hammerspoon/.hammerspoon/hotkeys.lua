-- Global variables
local hyper = { "ctrl", "alt", "cmd" }

-- Launch or focus specific applications
hs.hotkey.bind(hyper, "C", function()
	hs.application.launchOrFocus("Google Chrome")
end)

hs.hotkey.bind(hyper, "T", function()
	hs.application.launchOrFocus("iTerm")
end)

-- Lock the screen
hs.hotkey.bind(hyper, "L", function()
	hs.caffeinate.lockScreen()
end)

-- Reload Hammerspoon configuration
hs.hotkey.bind(hyper, "R", function()
	hs.reload()
end)
