-- Minimal Roblox environment stub for executing NevaUI outside Roblox.
-- Only implements what NevaUI touches, with enough fidelity to surface real
-- errors (unknown classes, wrong property names, nil calls).

local M = {}

local function makeColor(r, g, b)
        local c = { _r = r or 0, _g = g or 0, _b = b or 0 }
        return setmetatable(c, {
                __index = function(t, k)
                        if k == "R" then return rawget(t, "_r") end
                        if k == "G" then return rawget(t, "_g") end
                        if k == "B" then return rawget(t, "_b") end
                        if k == "Lerp" then
                                return function(_, other, alpha)
                                        local a = alpha or 0
                                        return makeColor(
                                                t._r + (other.R - t._r) * a,
                                                t._g + (other.G - t._g) * a,
                                                t._b + (other.B - t._b) * a
                                        )
                                end
                        end
                        if k == "ToHex" then
                                local function byte(v)
                                        return string.format("%02X", math.floor(math.clamp(v, 0, 1) * 255 + 0.5))
                                end
                                return function() return byte(t._r) .. byte(t._g) .. byte(t._b) end
                        end
                end,
                __tostring = function() return "Color3" end,
        })
end

local Color3 = {}
function Color3.new(r, g, b) return makeColor(r, g, b) end
function Color3.fromRGB(r, g, b) return makeColor((r or 0) / 255, (g or 0) / 255, (b or 0) / 255) end
function Color3.fromHex(hex)
        hex = tostring(hex):gsub("#", "")
        if #hex == 3 then
                hex = hex:sub(1, 1):rep(2) .. hex:sub(2, 2):rep(2) .. hex:sub(3, 3):rep(2)
        end
        return makeColor(
                (tonumber(hex:sub(1, 2), 16) or 0) / 255,
                (tonumber(hex:sub(3, 4), 16) or 0) / 255,
                (tonumber(hex:sub(5, 6), 16) or 0) / 255
        )
end
function Color3.fromHSV(h, s, v) return makeColor(h, s, v) end
function Color3.toHSV(c) return c.R, c.G, c.B end

local UDim = {}
function UDim.new(s, o) return { Scale = s or 0, Offset = o or 0 } end
UDim.fromScale = function(s) return UDim.new(s, 0) end
UDim.fromOffset = function(o) return UDim.new(0, o) end

local UDim2 = {}
function UDim2.new(xs, xo, ys, yo)
        return { X = UDim.new(xs, xo), Y = UDim.new(ys, yo) }
end
UDim2.fromScale = function(x, y) return UDim2.new(x, 0, y, 0) end
UDim2.fromOffset = function(x, y) return UDim2.new(0, x, 0, y) end

local Vector2 = {}
function Vector2.new(x, y)
        x, y = x or 0, y or 0
        return setmetatable({ X = x, Y = y, Magnitude = math.sqrt(x * x + y * y) }, {
                __add = function(a, b) return Vector2.new(a.X + b.X, a.Y + b.Y) end,
                __sub = function(a, b) return Vector2.new(a.X - b.X, a.Y - b.Y) end,
                __tostring = function() return "Vector2" end,
        })
end

local Vector3 = {}
local vector3Mt = {}
-- Vector arithmetic is used by camera framing code, so model it.
vector3Mt.__index = function(t, k)
        if k == "Magnitude" then
                return math.sqrt(t.X * t.X + t.Y * t.Y + t.Z * t.Z)
        end
        if k == "Unit" then
                local m = math.sqrt(t.X * t.X + t.Y * t.Y + t.Z * t.Z)
                if m == 0 then return Vector3.new(0, 0, 0) end
                return Vector3.new(t.X / m, t.Y / m, t.Z / m)
        end
        if k == "Dot" then
                return function(_, o) return t.X * o.X + t.Y * o.Y + t.Z * o.Z end
        end
        if k == "Cross" then
                return function(_, o)
                        return Vector3.new(
                                t.Y * o.Z - t.Z * o.Y,
                                t.Z * o.X - t.X * o.Z,
                                t.X * o.Y - t.Y * o.X
                        )
                end
        end
end
vector3Mt.__add = function(a, b) return Vector3.new(a.X + b.X, a.Y + b.Y, a.Z + b.Z) end
vector3Mt.__sub = function(a, b) return Vector3.new(a.X - b.X, a.Y - b.Y, a.Z - b.Z) end
vector3Mt.__mul = function(a, b)
        if type(a) == "number" then return Vector3.new(a * b.X, a * b.Y, a * b.Z) end
        if type(b) == "number" then return Vector3.new(a.X * b, a.Y * b, a.Z * b) end
        return Vector3.new(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
end
vector3Mt.__div = function(a, b)
        if type(b) == "number" then return Vector3.new(a.X / b, a.Y / b, a.Z / b) end
        return Vector3.new(a.X / b.X, a.Y / b.Y, a.Z / b.Z)
end
vector3Mt.__eq = function(a, b) return a.X == b.X and a.Y == b.Y and a.Z == b.Z end
vector3Mt.__tostring = function(t)
        return string.format("%g, %g, %g", t.X, t.Y, t.Z)
end
function Vector3.new(x, y, z)
        return setmetatable({ X = x or 0, Y = y or 0, Z = z or 0 }, vector3Mt)
end
Vector3.zero = Vector3.new(0, 0, 0)
Vector3.one = Vector3.new(1, 1, 1)

local CFrame = {}
-- Only the constructor and the fields NevaUI reads are modelled.
function CFrame.new(pos, lookAt)
        local position = pos or Vector3.new(0, 0, 0)
        local frame = {
                Position = position,
                LookVector = Vector3.new(0, 0, -1),
                X = position.X, Y = position.Y, Z = position.Z,
        }
        frame.__lookAt = lookAt
        return frame
end
CFrame.identity = CFrame.new(Vector3.new(0, 0, 0))
CFrame.Angles = function() return CFrame.new(Vector3.new(0, 0, 0)) end
CFrame.fromEulerAnglesXYZ = CFrame.Angles
CFrame.fromAxisAngle = function() return CFrame.new(Vector3.new(0, 0, 0)) end

local ColorSequenceKeypoint = { new = function(t, c) return { Time = t, Value = c } end }
local ColorSequence = {
        new = function(a, b)
                -- new(tableOfKeypoints) | new(kp0, kp1) | new(color0, color1)
                if type(a) == "table" and a.Time == nil then return { Keypoints = a } end
                if type(a) == "table" and a.Time then return { Keypoints = { a, b } } end
                return { Keypoints = { { Time = 0, Value = a }, { Time = 1, Value = b or a } } }
        end,
}
local NumberSequenceKeypoint = { new = function(t, v) return { Time = t, Value = v } end }
local NumberSequence = {
        new = function(a, b)
                if type(a) == "table" and a.Time == nil then return { Keypoints = a } end
                if type(a) == "table" and a.Time then return { Keypoints = { a, b } } end
                return { Keypoints = { { Time = 0, Value = a }, { Time = 1, Value = b or a } } }
        end,
}
local NumberRange = { new = function(a, b) return { Min = a, Max = b or a } end }
local Rect = { new = function(...) return { args = { ... } } end }
local TweenInfo = { new = function(...) return { args = { ... } } end }
local Font = { new = function(...) return { args = { ... } } end }
local Random = { new = function() return { NextNumber = function(_, a) return a or 0 end } end }

-- Enum: any field access yields a stable item object.
local Enum = setmetatable({}, {
        __index = function(t, enumName)
                local e = setmetatable({}, {
                        __index = function(self, itemName)
                                local item = { Name = itemName, Value = 0, EnumType = enumName }
                                rawset(self, itemName, item)
                                return item
                        end,
                })
                rawset(t, enumName, e)
                return e
        end,
})

-- Signals
local Signal = {}
Signal.__index = Signal
function Signal.new() return setmetatable({ _handlers = {} }, Signal) end
function Signal:Connect(fn)
        if type(fn) ~= "function" then
                error("Connect expects a function, got " .. type(fn))
        end
        table.insert(self._handlers, fn)
        return { Disconnect = function() end, Connected = true }
end
function Signal:Wait() end
function Signal:Fire(...)
        for _, fn in ipairs(self._handlers) do fn(...) end
end

-- Instance
local instanceMt = {}
local VALID_CLASSES = {}

-- Minimal ancestry so IsA("BasePart")/IsA("GuiObject") behave like Roblox.
local CLASS_PARENTS = {
        Part = { "BasePart", "PVInstance" },
        Model = { "PVInstance" },
        Frame = { "GuiObject", "GuiBase2d" },
        ScrollingFrame = { "GuiObject", "GuiBase2d" },
        TextLabel = { "GuiObject", "GuiBase2d" },
        TextButton = { "GuiObject", "GuiBase2d" },
        ImageLabel = { "GuiObject", "GuiBase2d" },
        ImageButton = { "GuiObject", "GuiBase2d" },
        TextBox = { "GuiObject", "GuiBase2d" },
        CanvasGroup = { "GuiObject", "GuiBase2d" },
        ViewportFrame = { "GuiObject", "GuiBase2d" },
        VideoFrame = { "GuiObject", "GuiBase2d" },
        BasePart = { "PVInstance" },
}
for _, n in ipairs({
        "Frame", "ScrollingFrame", "TextLabel", "TextButton", "ImageLabel", "ImageButton",
        "TextBox", "UIListLayout", "UIGridLayout", "UIPadding", "UICorner", "UIStroke",
        "UIScale", "UIGradient", "UIAspectRatioConstraint", "UISizeConstraint",
        "ScreenGui", "Folder", "CanvasGroup", "ViewportFrame", "Camera", "WorldModel",
        "BindableEvent", "BindableFunction", "StringValue", "NumberValue", "BoolValue",
        "ObjectValue", "LocalScript", "ModuleScript", "Part", "Model", "Attachment",
        "Decal", "Texture", "VideoFrame", "Highlight", "UIShadow", "UIFlexItem",
        "BillboardGui", "Sound", "UIShadow", "UITextSizeConstraint",
}) do
        VALID_CLASSES[n] = true
end

local DEFAULT_PROPS = {
        Name = "Instance", Visible = true, Active = false,
        BackgroundTransparency = 0, TextTransparency = 0, ImageTransparency = 0,
        Transparency = 0, ZIndex = 1, LayoutOrder = 0, Rotation = 0,
        Size = UDim2.new(0, 100, 0, 100), Position = UDim2.new(0, 0, 0, 0),
        AbsolutePosition = Vector2.new(0, 0), AbsoluteSize = Vector2.new(100, 100),
        AbsoluteContentSize = Vector2.new(100, 100), AnchorPoint = Vector2.new(0, 0),
        AutoButtonColor = true, ClipsDescendants = false, ScrollingEnabled = true,
        CanvasSize = UDim2.new(0, 0, 0, 0), CanvasPosition = Vector2.new(0, 0),
        Text = "", TextSize = 14, Font = Enum.Font.SourceSans,
        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
        TextBounds = Vector2.new(0, 14), TextFits = true, TextWrapped = false,
        TextScaled = false, TextTruncate = Enum.TextTruncate.None,
        TextStrokeTransparency = 1, TextStrokeColor3 = makeColor(0, 0, 0),
        LineHeight = 1, MaxVisibleGraphemes = -1, RichText = false,
        AutomaticSize = Enum.AutomaticSize.None, ContentText = "",
        CursorPosition = -1, SelectionStart = -1, MultiLine = false,
        ClearTextOnFocus = true,
        Image = "", ImageColor3 = makeColor(1, 1, 1), ImageTransparency = 0,
        ImageRectOffset = Vector2.new(0, 0), ImageRectSize = Vector2.new(0, 0),
        ScaleType = Enum.ScaleType.Stretch, SliceCenter = Rect.new(0, 0, 0, 0),
        TileSize = UDim2.new(1, 0, 1, 0), ResampleMode = Enum.ResamplerMode.Default,
        PlaceholderText = "", PlaceholderColor3 = makeColor(1, 1, 1),
        TextEditable = true, ShowNativeInput = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
        BorderSizePixel = 0, BackgroundColor3 = makeColor(1, 1, 1),
        BorderColor3 = makeColor(0, 0, 0), DisplayOrder = 0, Enabled = true,
        ResetOnSpawn = false, IgnoreGuiInset = false, AutoLocalize = false,
        Selectable = false, SelectionGroup = false, Interactable = true,
        Draggable = false, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
        LineJoinMode = Enum.LineJoinMode.Round,
        -- UIGradient.Color/Transparency are sequences, not scalars.
        Color = ColorSequence.new(makeColor(1, 1, 1)),
        Transparency = NumberSequence.new(0),
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 0),
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        FillDirectionMaxCells = 0, Wraps = false, HorizontalFlex = Enum.UIFlexAlignment.None,
        VerticalFlex = Enum.UIFlexAlignment.None, ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
        FlexMode = Enum.UIFlexMode.None, GrowRatio = 1, ShrinkRatio = 1, Spacing = 0,
        CellSize = UDim2.new(0, 100, 0, 100), CellPadding = UDim2.new(0, 0, 0, 0),
        FillEmptySpaceColumns = false, FillEmptySpaceRows = false,
        MaxSize = Vector2.new(math.huge, math.huge), MinSize = Vector2.new(0, 0),
        AspectRatio = 1, AspectType = Enum.AspectType.FitWithinMaxSize,
        DominantAxis = Enum.DominantAxis.Width, Scale = 1,
        Value = "",
}

local SIGNALS = {
        "MouseButton1Click", "MouseButton2Click", "MouseButton1Down", "MouseButton1Up",
        "MouseEnter", "MouseLeave", "InputBegan", "InputEnded", "InputChanged",
        "Changed", "FocusLost", "Focused", "ReturnPressed", "Activated",
        "ChildAdded", "ChildRemoved", "DescendantAdded", "AncestryChanged",
        "Destroying", "MouseWheelForward", "MouseWheelBackward", "TouchTap",
        "TouchPinch", "TouchLongPress", "TouchStarted", "TouchMoved", "TouchEnded",
}

instanceMt.__index = function(t, k)
        local props = rawget(t, "_props")
        if props[k] ~= nil then return props[k] end
        for _, c in ipairs(rawget(t, "_children")) do
                if c.Name == k then return c end
        end
        local methods = rawget(t, "_methods")
        if methods[k] then return methods[k] end
        return nil
end

instanceMt.__newindex = function(t, k, v)
        local props = rawget(t, "_props")
        if k == "Parent" then
                local old = props.Parent
                if old then
                        local kids = rawget(old, "_children")
                        for i, c in ipairs(kids) do
                                if c == t then table.remove(kids, i) break end
                        end
                end
                props.Parent = v
                if v then table.insert(rawget(v, "_children"), t) end
                return
        end
        props[k] = v
end

local function makeInstance(className)
        local self = setmetatable({ _props = {}, _children = {}, _methods = {}, _signals = {} }, instanceMt)
        for k, v in pairs(DEFAULT_PROPS) do
                self._props[k] = v
        end
        self._props.ClassName = className
        self._props.Name = className

        -- 3D instances use Vector3 geometry, not the GUI UDim2 defaults.
        if className == "Part" or className == "MeshPart" or className == "Model" then
                self._props.Size = Vector3.new(4, 1, 2)
                self._props.Position = Vector3.new(0, 0, 0)
                self._props.CFrame = CFrame.new(Vector3.new(0, 0, 0))
                self._props.Anchored = false
                self._props.CanCollide = true
        end

        for _, sig in ipairs(SIGNALS) do
                self._props[sig] = Signal.new()
        end

        local m = self._methods
        m.GetPropertyChangedSignal = function(_, prop)
                local key = "__prop_" .. tostring(prop)
                if not self._signals[key] then self._signals[key] = Signal.new() end
                return self._signals[key]
        end
        m.GetChildren = function()
                local out = {}
                for i, c in ipairs(rawget(self, "_children")) do out[i] = c end
                return out
        end
        m.GetDescendants = function()
                local out = {}
                local function walk(node)
                        for _, c in ipairs(rawget(node, "_children")) do
                                table.insert(out, c)
                                walk(c)
                        end
                end
                walk(self)
                return out
        end
        m.FindFirstChild = function(_, name, recursive)
                for _, c in ipairs(rawget(self, "_children")) do
                        if c.Name == name then return c end
                end
                if recursive then
                        for _, c in ipairs(rawget(self, "_children")) do
                                local f = m.FindFirstChild(c, name, true)
                                if f then return f end
                        end
                end
                return nil
        end
        m.FindFirstChildOfClass = function(_, cls)
                for _, c in ipairs(rawget(self, "_children")) do
                        if c.ClassName == cls then return c end
                end
                return nil
        end
        m.FindFirstChildWhichIsA = m.FindFirstChildOfClass
        m.WaitForChild = function(_, name)
                local f = m.FindFirstChild(self, name)
                if f then return f end
                error("WaitForChild timed out: " .. tostring(name))
        end
        m.IsA = function(_, cls)
                local actual = rawget(self, "_props").ClassName
                if actual == cls then return true end
                -- Walk the ancestry so Part:IsA("BasePart") behaves like Roblox.
                local parents = CLASS_PARENTS[actual]
                while parents do
                        for _, p in ipairs(parents) do
                                if p == cls then return true end
                        end
                        local nextParents = {}
                        for _, p in ipairs(parents) do
                                for _, gp in ipairs(CLASS_PARENTS[p] or {}) do
                                        table.insert(nextParents, gp)
                                end
                        end
                        parents = #nextParents > 0 and nextParents or nil
                end
                return false
        end
        m.GetBoundingBox = function()
                local size = rawget(self, "_props").Size or Vector3.new(4, 1, 2)
                local position = rawget(self, "_props").Position or Vector3.new(0, 0, 0)
                if type(size.X) ~= "number" then size = Vector3.new(4, 1, 2) end
                if type(position.X) ~= "number" then position = Vector3.new(0, 0, 0) end
                return CFrame.new(position), size
        end
        m.GetPivot = function()
                local position = rawget(self, "_props").Position or Vector3.new(0, 0, 0)
                if type(position.X) == "number" then
                        return CFrame.new(position)
                end
                return CFrame.new(Vector3.new(0, 0, 0))
        end
        m.PivotTo = function() end
        m.Clone = function() return makeInstance(rawget(self, "_props").ClassName) end
        m.Destroy = function()
                local p = rawget(self, "_props").Parent
                if p then
                        local kids = rawget(p, "_children")
                        for i, c in ipairs(kids) do
                                if c == self then table.remove(kids, i) break end
                        end
                end
                rawget(self, "_props").Parent = nil
        end
        m.ClearAllChildren = function() rawset(self, "_children", {}) end
        m.TweenPosition = function() end
        m.TweenSize = function() end
        m.GetAttribute = function() return nil end
        m.SetAttribute = function() end
        m.GetFullName = function() return rawget(self, "_props").Name end

        return self
end

local Instance = {}
function Instance.new(className, parent)
        if not VALID_CLASSES[className] then
                error("Instance.new: unknown ClassName '" .. tostring(className) .. "'")
        end
        local obj = makeInstance(className)
        if parent then obj.Parent = parent end
        return obj
end

local function typeof(v)
        if type(v) ~= "table" then return type(v) end
        local mt = getmetatable(v)
        if mt == instanceMt then return "Instance" end
        if mt and mt.__tostring and mt.__tostring(v) == "Color3" then return "Color3" end
        return "table"
end

-- Services
local services = {}
local function service(name)
        if services[name] then return services[name] end
        local s = makeInstance("Folder")
        s.Name = name
        services[name] = s
        return s
end

local rs = service("ReplicatedStorage")
local getIcons = makeInstance("BindableFunction")
getIcons.Name = "GetIcons"
getIcons.Parent = rs
getIcons.InvokeServer = function()
        return {
                Icons = {},
                GetIcon = function(_, iconName)
                        return { Image = "rbxassetid://0", ImageRectSize = Vector2.new(0, 0), ImageRectPosition = Vector2.new(0, 0) }
                end,
                GetIcons = function() return {} end,
                Icon2 = function(_, iconName)
                        return { "rbxassetid://0", { ImageRectPosition = Vector2.new(0, 0), ImageRectSize = Vector2.new(0, 0) } }
                end,
        }
end

local Player = makeInstance("Folder")
Player.Name = "Tester"
Player.UserId = 1
Player.DisplayName = "Tester"
Player.GetRankInGroup = function() return 0 end
Player.IsFriendsWith = function() return false end
Player.Kick = function() end
Player.GetMouse = function()
        return {
                X = 0, Y = 0,
                UnitRay = { Origin = Vector3.new(0, 0, 0), Direction = Vector3.new(0, 0, -1) },
                Hit = nil,
                Target = nil,
                Icon = "",
                Move = Signal.new(),
                Button1Down = Signal.new(),
                Button1Up = Signal.new(),
                KeyDown = Signal.new(),
                KeyUp = Signal.new(),
                WheelForward = Signal.new(),
                WheelBackward = Signal.new(),
        }
end

local Players = service("Players")
Players.LocalPlayer = Player
Players.GetPlayers = function() return { Player } end
Players.GetUserThumbnailAsync = function(_, userId, size, format)
        return "rbxassetid://0", true
end
Players.PlayerAdded = Signal.new()
Players.PlayerRemoving = Signal.new()

local CoreGui = service("CoreGui")
local RobloxGui = makeInstance("Folder")
RobloxGui.Name = "RobloxGui"
RobloxGui.Parent = CoreGui

local UIS = service("UserInputService")
UIS.MouseEnabled = true
UIS.KeyboardEnabled = true
UIS.TouchEnabled = false
UIS.GamepadEnabled = false
UIS.GetMouseLocation = function() return Vector2.new(0, 0) end
UIS.GetFocusedTextBox = function() return nil end
UIS.IsKeyDown = function() return false end

local RunService = service("RunService")
-- Report a live client, not Studio, so the config system and executor-only
-- paths actually run instead of warning and short-circuiting.
RunService.IsStudio = function() return false end
RunService.IsClient = function() return true end
RunService.IsServer = function() return false end
RunService.IsRunning = function() return false end
RunService.RenderStepped = Signal.new()
RunService.Heartbeat = Signal.new()
RunService.Stepped = Signal.new()
RunService.BindToRenderStep = function() end
RunService.UnbindFromRenderStep = function() end

local TweenService = service("TweenService")
TweenService.Create = function(_, obj, info, goal)
        if type(goal) == "table" then
                for k, v in pairs(goal) do
                        pcall(function() obj[k] = v end)
                end
        end
        local tween = { Play = function() return tween end, Cancel = function() return tween end, Pause = function() return tween end, Completed = Signal.new() }
        return tween
end

local HttpService = service("HttpService")
HttpService.JSONEncode = function(_, t) return "{}" end
-- Minimal recursive-descent JSON decoder so config and package metadata
-- round-trip with real values instead of empty tables.
local function __jsonDecode(text)
        local pos = 1
        local function skip()
                while true do
                        local c = text:sub(pos, pos)
                        if c == " " or c == "\t" or c == "\n" or c == "\r" then pos += 1 else break end
                end
        end
        local parseValue
        local function parseString()
                pos += 1
                local out = {}
                while true do
                        local c = text:sub(pos, pos)
                        if c == "" then error("unterminated string") end
                        if c == "\\" then
                                local esc = text:sub(pos + 1, pos + 1)
                                local map = { n = "\n", t = "\t", r = "\r", b = "\b", f = "\f", ["\""] = "\"", ["\\"] = "\\", ["/"] = "/" }
                                if esc == "u" then
                                        local code = tonumber(text:sub(pos + 2, pos + 5), 16) or 63
                                        table.insert(out, utf8.char(code))
                                        pos += 6
                                else
                                        table.insert(out, map[esc] or esc)
                                        pos += 2
                                end
                        elseif c == "\"" then
                                pos += 1
                                return table.concat(out)
                        else
                                table.insert(out, c)
                                pos += 1
                        end
                end
        end
        local function parseNumber()
                local startPos = pos
                while text:sub(pos, pos):match("[%d%.eE%+%-]") do pos += 1 end
                return tonumber(text:sub(startPos, pos - 1))
        end
        local function parseArray()
                pos += 1
                local arr = {}
                skip()
                if text:sub(pos, pos) == "]" then pos += 1 return arr end
                while true do
                        table.insert(arr, parseValue())
                        skip()
                        local c = text:sub(pos, pos)
                        if c == "," then pos += 1 skip() else pos += 1 break end
                end
                return arr
        end
        local function parseObject()
                pos += 1
                local obj = {}
                skip()
                if text:sub(pos, pos) == "}" then pos += 1 return obj end
                while true do
                        skip()
                        local key = parseString()
                        skip()
                        pos += 1 -- colon
                        obj[key] = parseValue()
                        skip()
                        local c = text:sub(pos, pos)
                        if c == "," then pos += 1 else pos += 1 break end
                end
                return obj
        end
        parseValue = function()
                skip()
                local c = text:sub(pos, pos)
                if c == "{" then return parseObject() end
                if c == "[" then return parseArray() end
                if c == "\"" then return parseString() end
                if text:sub(pos, pos + 3) == "true" then pos += 4 return true end
                if text:sub(pos, pos + 4) == "false" then pos += 5 return false end
                if text:sub(pos, pos + 3) == "null" then pos += 4 return nil end
                return parseNumber()
        end
        return parseValue()
end

HttpService.JSONDecode = function(_, s)
        local ok, decoded = pcall(__jsonDecode, tostring(s))
        return ok and decoded or {}
end
HttpService.GenerateGUID = function() return "guid-1" end

local LocalizationService = service("LocalizationService")
LocalizationService.RobloxLocaleId = "en-us"
LocalizationService.SystemLocaleId = "en-us"
LocalizationService.GetTranslatorForLocaleAsync = function() end

local TextService = service("TextService")
TextService.GetTextSize = function(_, text, size) return Vector2.new(#tostring(text) * 7, size or 14) end

local GuiService = service("GuiService")
GuiService.SelectedObject = nil
GuiService.IsTenFootInterface = function() return false end

service("StarterGui").SetCoreGuiEnabled = function() end
service("ContextActionService").BindAction = function() end
service("CollectionService").GetTagged = function() return {} end

local game = {}
game.GetService = function(_, name) return service(name) end
game.HttpGet = function() return "" end
game.GetObjects = function() return {} end
game.Shutdown = function() end
game.PlaceId = 0
game.JobId = "job"

local workspaceService = service("Workspace")
local camera = makeInstance("Camera")
camera.ViewportSize = Vector2.new(1920, 1080)
camera.CFrame = { Position = Vector3.new(0, 0, 0) }
workspaceService.CurrentCamera = camera
workspaceService.GetPropertyChangedSignal = function() return Signal.new() end

local env = {}
env.Instance = Instance
env.UDim = UDim
env.UDim2 = UDim2
env.Vector2 = Vector2
env.Vector3 = Vector3
env.CFrame = CFrame
env.Color3 = Color3
env.ColorSequence = ColorSequence
env.ColorSequenceKeypoint = ColorSequenceKeypoint
env.NumberSequence = NumberSequence
env.NumberSequenceKeypoint = NumberSequenceKeypoint
env.NumberRange = NumberRange
env.Rect = Rect
env.TweenInfo = TweenInfo
env.Enum = Enum
env.Font = Font
env.Random = Random
env.game = game
env.workspace = service("Workspace")
env.script = makeInstance("ModuleScript")
env.typeof = typeof
env.warn = function(...)
        local parts = {}
        for _, v in ipairs({ ... }) do table.insert(parts, tostring(v)) end
        print("[warn] " .. table.concat(parts, " "))
end
-- Cooperative scheduler: task.wait yields, task.spawn drains a queue. A resume
-- budget keeps endless render/clock loops from hanging the harness.
local __ResumeBudget = 2000
local __Draining = false
local __Queue = {}
local __Errors = {}

local function __Resume(co, ...)
        if __ResumeBudget <= 0 then return false end
        __ResumeBudget -= 1
        local ok, err = coroutine.resume(co, ...)
        if not ok then
                -- Swallowing this hides every error raised inside a spawned thread,
                -- which makes failures look like silent no-ops.
                local trace = debug and debug.traceback and debug.traceback(co) or ""
                table.insert(__Errors, tostring(err) .. "\n" .. trace)
        end
        return ok, err
end

env.__errors = __Errors

local function __Drain()
        if __Draining then return end
        __Draining = true
        while #__Queue > 0 and __ResumeBudget > 0 do
                local co = table.remove(__Queue, 1)
                if coroutine.status(co) == "suspended" then
                        __Resume(co)
                end
        end
        __Draining = false
end

local function __Spawn(fn, ...)
        local co = coroutine.create(fn)
        __Resume(co, ...)
        if coroutine.status(co) == "suspended" then
                table.insert(__Queue, co)
        end
        __Drain()
        return co
end

env.task = {
        wait = function(t)
                if coroutine.isyieldable() then coroutine.yield(t or 0) end
                return t or 0
        end,
        spawn = __Spawn,
        defer = __Spawn,
        delay = function(_, fn, ...) return __Spawn(fn, ...) end,
        cancel = function() end,
}
env.resume = function(co, ...) return __Resume(co, ...) end
-- Exposed so the harness can run the example on a yieldable thread.
env.__spawn = __Spawn
env.wait = env.task.wait
env.spawn = env.task.spawn
env.delay = env.task.delay
env.tick = os.time
-- Executor globals real scripts commonly probe for.
env.printidentity = function() return 2 end
env.getidentity = function() return 2 end
env.time = os.time
env.isfolder = function() return true end
env.isfile = function() return false end
env.makefolder = function() end
env.writefile = function() end
env.readfile = function() return "" end
env.delfile = function() end
env.listfiles = function() return {} end
env.setclipboard = function() end
env.gethwid = function() return "test-hwid" end
env.getgenv = function() return {} end
env.identifyexecutor = function() return "TestExecutor", "1.0.0" end
env.getcustomasset = function(path) return "rbxasset://" .. tostring(path) end
env.cloneref = function(instance) return instance end
env.protectgui = function() end
env.gethui = function() return service("CoreGui") end
env.setthreadidentity = function() end
env.checkcaller = function() return false end
env.getrawmetatable = function(t) return getmetatable(t) end
env.setreadonly = function() end
env.hookfunction = function() end
env.require = require
env.loadstring = loadstring
env.unpack = table.unpack
env.newproxy = function() return {} end

-- Roblox globals sit on top of the standard library rather than replacing it.
return setmetatable(env, { __index = _G })
