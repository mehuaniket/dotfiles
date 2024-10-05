-- Hammerspoon Configuration

-- Global variables
local hyper = { "ctrl", "alt", "cmd" }

-- Window Management Functions
-- Move window to the left half of the screen
hs.hotkey.bind(hyper, "Left", function()
	local win = hs.window.focusedWindow()
	local screen = win:screen()
	local max = screen:frame()

	win:setFrame(hs.geometry.rect(max.x, max.y, max.w / 2, max.h))
end)

-- Move window to the right half of the screen
hs.hotkey.bind(hyper, "Right", function()
	local win = hs.window.focusedWindow()
	local screen = win:screen()
	local max = screen:frame()

	win:setFrame(hs.geometry.rect(max.x + (max.w / 2), max.y, max.w / 2, max.h))
end)

-- Maximize window
hs.hotkey.bind(hyper, "Up", function()
	local win = hs.window.focusedWindow()
	win:maximize()
end)

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

-- Clipboard Manager Example
clipboard_history = {}

-- Function to save current clipboard contents to history
function saveClipboard()
	local content = hs.pasteboard.getContents()
	if content ~= nil and content ~= "" then
		table.insert(clipboard_history, content)
	end
end

-- Hotkey to display clipboard history
hs.hotkey.bind(hyper, "V", function()
	local choices = hs.fnutils.imap(clipboard_history, function(item)
		return { text = item }
	end)
	local chooser = hs.chooser.new(function(choice)
		if choice then
			hs.pasteboard.setContents(choice.text)
		end
	end)
	chooser:choices(choices)
	chooser:show()
end)

-- Automatically save clipboard contents when it changes
hs.pasteboard.watcher.new(saveClipboard):start()

-- Notify when Hammerspoon is loaded
hs.notify.new({ title = "Hammerspoon", informativeText = "Config loaded" }):send()

-- Function to move the mouse to the center of the focused window
function focusMouseOnWindow()
	-- Get the currently focused window
	local win = hs.window.focusedWindow()

	if win then
		-- Get the frame (position and size) of the focused window
		local frame = win:frame()

		-- Calculate the center of the window
		local center = hs.geometry.rectMidPoint(frame)

		-- Move the mouse to the center of the window
		hs.mouse.absolutePosition(center)
	end
end

-- Bind the function to the window focus change event
hs.window.filter.default:subscribe(hs.window.filter.windowFocused, focusMouseOnWindow)

-- Notify when Hammerspoon is loaded and this functionality is active
hs.notify.new({ title = "Hammerspoon", informativeText = "Mouse will follow window focus" }):send()

-- **Toggle Full Screen (Option + F)**
hs.hotkey.bind(hyper, "F", function()
	local win = hs.window.focusedWindow() -- Get the focused window
	if win then
		win:toggleFullScreen() -- Toggle full screen
	end
end)

-- Notify when configuration is loaded
hs.notify.new({ title = "Hammerspoon", informativeText = "Full screen toggle loaded" }):send()
