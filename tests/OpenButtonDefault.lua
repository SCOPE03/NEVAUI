-- Regression test for the default floating open button behaviour.
--
-- Without CloseOnClick the button must keep its original meaning: it hides while
-- the window is open and it only ever opens the window.
local NevaUI = require("../src/Init")

local Window = NevaUI:CreateWindow({
        Title = "OpenButton Default Test",
        Size = UDim2.fromOffset(660, 480),
        Folder = "NevaUIDefaultTest",
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
        },
})

Window:Tab({ Title = "One", Icon = "solar:widget-bold" })

local Button = Window.OpenButtonMain

assert(Button, "open button module should exist")
assert(Button.CloseOnClick == false, "CloseOnClick must be off by default")

task.spawn(function()
        task.wait(0.5)

        assert(Window.Closed == false, "window should be open")
        assert(
                Button.Button.Parent.Visible == false,
                "a plain open button must hide while the window is open"
        )

        -- Closing must not be turned into a toggle: Closed flips, and the button
        -- keeps its original "open only" meaning.
        Window:Close()
        assert(Window.Closed == true, "window should be closed")

        print("OpenButtonDefault: all assertions passed")
end)
