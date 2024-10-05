-- Hammerspoon Configuration
hs = hs or {}
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

-- Function to safely move the window between screens and handle full-screen mode correctly
function moveWindowToScreen(win, screenFn)
	if not win then
		return
	end -- Return if no window is focused

	local isFullScreen = win:isFullScreen() -- Check if the window is in full-screen mode

	if isFullScreen then
		win:setFullScreen(false) -- Exit full-screen mode
		hs.timer.doAfter(0.5, function() -- Allow time for animation to finish
			local screen = win:screen() -- Get the current screen of the window
			local targetScreen = screenFn(screen) -- Get the target screen (next or previous)

			-- Move the window to the target screen and ensure it's not in full screen
			moveToScreenAvoidFullScreen(win, targetScreen)

			hs.timer.doAfter(0.2, function() -- Slight delay to ensure the move is applied
				-- Move cursor to the center of the window
				centerMouseInWindow(win)
			end)
		end)
	else
		local screen = win:screen() -- Get the current screen of the window
		local targetScreen = screenFn(screen) -- Get the target screen (next or previous)

		-- Move the window to the target screen and ensure it's not in full screen
		moveToScreenAvoidFullScreen(win, targetScreen)

		-- Move cursor to the center of the window
		centerMouseInWindow(win)
	end
end

-- Function to safely move the window between screens and handle full-screen mode correctly
function moveWindowToScreen(win, screenFn)
	if not win then
		return
	end -- Return if no window is focused

	local isFullScreen = win:isFullScreen() -- Check if the window is in full-screen mode

	-- If the window is in full-screen mode, exit full-screen before moving
	if isFullScreen then
		win:setFullScreen(false) -- Exit full-screen mode
		hs.timer.usleep(500000) -- Wait for the full-screen exit animation to complete (0.5 seconds)
	end

	-- Move the window to the target screen (next or previous)
	local screen = win:screen() -- Get the current screen of the window
	local targetScreen = screenFn(screen) -- Get the target screen (next or previous)
	win:moveToScreen(targetScreen, true, true) -- Move the window to the target screen

	-- Move the cursor to the center of the window after moving
	centerMouseInWindow(win)

	-- Focus the window to ensure it's visible and active on the new display
	hs.timer.doAfter(0.1, function()
		win:focus()
	end)
	-- Delay to allow the move operation to finish, then re-enter full-screen mode if necessary
	if isFullScreen then
		hs.timer.doAfter(1.0, function() -- Wait 1 second for the move to complete
			win:setFullScreen(true) -- Re-enter full-screen mode
		end)
	end
end

-- Function to move the cursor to the center of a window
function centerMouseInWindow(win)
	if not win then
		return
	end -- Return if no window is focused

	local frame = win:frame() -- Get the window's frame (position and size)
	local centerX = frame.x + (frame.w / 2) -- Calculate the center X position
	local centerY = frame.y + (frame.h / 2) -- Calculate the center Y position

	-- Move the mouse to the center of the window
	hs.mouse.absolutePosition({ x = centerX, y = centerY })
end

-- Move the current window to the next screen
function moveWindowToNextDisplay()
	local win = hs.window.focusedWindow()
	moveWindowToScreen(win, function(screen)
		return screen:next()
	end)
end

-- Move the current window to the previous screen
function moveWindowToPreviousDisplay()
	local win = hs.window.focusedWindow()
	moveWindowToScreen(win, function(screen)
		return screen:previous()
	end)
end

-- Set up hotkeys: 'J' for previous display and 'K' for next display
hs.hotkey.bind(hyper, "J", moveWindowToPreviousDisplay)
hs.hotkey.bind(hyper, "K", moveWindowToNextDisplay)

-- Function to reload Hammerspoon configuration
function reloadConfig()
	hs.reload()
end

-- Bind a hotkey to reload the Hammerspoon configuration
hs.hotkey.bind(hyper, "R", reloadConfig)

-- Reload Hammerspoon configuration
hs.alert.show("Hammerspoon config loaded")
