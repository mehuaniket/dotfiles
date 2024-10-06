--- === MoveWindowBetweenScreens ===
---
--- This Spoon moves windows between screens and handles full-screen mode correctly.
---
--- Download: [https://github.com/yourusername/MoveWindowBetweenScreens.spoon](https://github.com/yourusername/MoveWindowBetweenScreens.spoon)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "MoveWindowBetweenScreens"
obj.version = "1.0"
obj.author = "Aniket Patel <8078990+mehuaniket@users.noreply.github.com>>"
obj.homepage =
	"https://github.com/mehuaniket/dotfiles/tree/main/hammerspoon/.hammerspoon/Spoons/MoveWindowBetweenScreens.spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Function to safely move the window between screens and handle full-screen mode correctly
function obj:moveWindowToScreen(win, screenFn)
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
	self:centerMouseInWindow(win)

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
function obj:centerMouseInWindow(win)
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
function obj:moveWindowToNextDisplay()
	local win = hs.window.focusedWindow()
	self:moveWindowToScreen(win, function(screen)
		return screen:next()
	end)
end

-- Move the current window to the previous screen
function obj:moveWindowToPreviousDisplay()
	local win = hs.window.focusedWindow()
	self:moveWindowToScreen(win, function(screen)
		return screen:previous()
	end)
end

-- Set up hotkeys
function obj:bindHotkeys(mapping)
	local def = {
		moveWindowToNextDisplay = hs.fnutils.partial(self.moveWindowToNextDisplay, self),
		moveWindowToPreviousDisplay = hs.fnutils.partial(self.moveWindowToPreviousDisplay, self),
	}
	hs.spoons.bindHotkeysToSpec(def, mapping)
end

return obj
