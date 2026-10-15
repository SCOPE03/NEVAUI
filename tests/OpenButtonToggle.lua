-- Regression test for the floating open button acting as a toggle.
--
-- The button used to only ever call Window:Open(), so once the window was open
-- the button was hidden and there was no way to close the window from it. With
-- CloseOnClick the button stays on screen while the window is open and a click
-- closes it again.
--
-- The window is created at the top level (as real scripts do) and the assertions
-- run after a single task.wait, because the harness scheduler only resumes a
-- coroutine across one wait.
local NevaUI = require("../src/Init")

local Window = NevaUI:CreateWindow({
        Title = "OpenButton Toggle Test",
        Size = UDim2.fromOffset(660, 480),
        Folder = "NevaUIToggleTest",
        Sidebar = {
                Position = "Left",
                Type = "Default",
                Width = 210,
                Brand = { Layout = "Horizontal", Title = "NevaUI", Height = 56 },
        },
        OpenButton = {
                Floating = true,
                OnlyMobile = false,
                OnlyIcon = true,
                CloseOnClick = true,
        },
})

Window:Tab({ Title = "One", Icon = "solar:widget-bold" })

-- The config propagates synchronously when the window is built, so the button
-- must already know it is a toggle before the window finishes opening.
local Button = Window.OpenButtonMain

assert(Button, "open button module should exist")
assert(Button.CloseOnClick == true, "CloseOnClick should propagate to the button")
assert(Button.Floating == true, "Floating should propagate to the button")

task.spawn(function()
        task.wait(0.5)

        assert(Window.Closed == false, "window should be open")
        assert(
                Button.Button.Parent.Visible == true,
                "a CloseOnClick button must stay visible while the window is open"
        )

        Button.Button.TextButton.MouseButton1Click:Fire()
        assert(Window.Closed == true, "clicking a CloseOnClick button must close the window")

        print("OpenButtonToggle: all assertions passed")
end)
