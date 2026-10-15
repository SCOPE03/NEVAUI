-- Regression test for sidebar rail placement.
--
-- The right-hand rail used to be positioned with a negative width offset while
-- anchored to the right edge, which pushed it to (windowWidth - SideBarWidth)
-- and left it floating in the middle of the window. These assertions pin the
-- declared geometry for every position.
local NevaUI = require("../src/Init")

local Window = NevaUI:CreateWindow({
        Title = "Sidebar Layout Test",
        Size = UDim2.fromOffset(660, 480),
        Sidebar = {
                Position = "Right",
                Type = "Default",
                Width = 210,
                Padding = 10,
                Gap = 8,
                Brand = { Layout = "Horizontal", Title = "NevaUI", Height = 56 },
                TabHeight = 34,
        },
})

Window:Tab({ Title = "One", Icon = "solar:widget-bold" })
Window:Tab({ Title = "Two", Icon = "solar:star-bold" })

local UI = Window.UIElements
local Container = UI.SideBarContainer
local MainBar = UI.MainBar

local function checkRail(Position, ExpectScale, ExpectAnchorX)
        Window:SetSidebarPosition(Position)

        assert(Window.SidebarPosition == Position, "position should update")
        assert(Container.Position.X.Scale == ExpectScale, Position .. " rail X scale")
        assert(Container.Position.X.Offset == 0, Position .. " rail must not offset horizontally")
        assert(Container.AnchorPoint.X == ExpectAnchorX, Position .. " rail anchor")
        assert(Container.Size.X.Offset == Window.SideBarWidth, Position .. " rail width")

        -- The rail must never sit over the content area.
        assert(MainBar.Size.X.Offset == -Window.SideBarWidth, Position .. " content must reserve the rail")
end

checkRail("Left", 0, 0)
checkRail("Right", 1, 1)

-- Position and Type are independent: a type change must not move the rail.
for _, kind in ipairs({ "Default", "Icon", "Compact", "Segmented" }) do
        Window:SetSidebarType(kind)
        assert(Window.SideBarWidth == 210, kind .. " must not override a pinned width")
        checkRail("Right", 1, 1)
        checkRail("Left", 0, 0)
end

-- A Top rail spans the full width below the topbar instead of reserving columns.
Window:SetSidebarPosition("Top")
assert(Container.Position.X.Scale == 0 and Container.Position.X.Offset == 0, "top rail starts at the left edge")
assert(Container.Position.Y.Offset == Window.Topbar.Height, "top rail sits below the topbar")
assert(Container.Size.X.Scale == 1 and Container.Size.Y.Scale == 0, "top rail spans the window width")
assert(MainBar.Size.X.Offset == 0, "top rail must not reserve content width")

-- SetSidebarWidth must re-apply the layout without disturbing the position.
Window:SetSidebarPosition("Right")
Window:SetSidebarWidth(180)
assert(Window.SideBarWidth == 180, "width should update")
assert(Container.Position.X.Scale == 1 and Container.Position.X.Offset == 0, "width change keeps the rail flush")
assert(Container.Size.X.Offset == 180, "rail width should follow")

print("SidebarLayout: all assertions passed")
