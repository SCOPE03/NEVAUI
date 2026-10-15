local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local Players = game:GetService("Players")

local UserInputService = cloneref(game:GetService("UserInputService"))
local Mouse = Players.LocalPlayer:GetMouse()

local Creator = require("../../modules/Creator")
local New = Creator.New

local CreateToolTip = require("../ui/Tooltip").New
local CreateScrollSlider = require("../ui/ScrollSlider").New

local Window, NevaUI, UIScale

local TabModule = {
	--Window = nil,
	--NevaUI = nil,
	Tabs = {},
	Containers = {},
	SelectedTab = nil,
	TabCount = 0,
	ToolTipParent = nil,
	TabHighlight = nil,

	OnChangeFunc = function(v) end,
	OnSelectorTargetFunc = function(v) end,
}

function TabModule:OnSelectorTarget(func)
	TabModule.OnSelectorTargetFunc = func
end

function TabModule.Init(WindowTable, NevaUITable, ToolTipParent, TabHighlight)
	Window = WindowTable
	NevaUI = NevaUITable
	TabModule.ToolTipParent = ToolTipParent
	TabModule.TabHighlight = TabHighlight
	return TabModule
end

function TabModule.New(Config, UIScale)
	local Tab = {
		__type = "Tab",
		Title = Config.Title or "Tab",
		Desc = Config.Desc,
		Icon = Config.Icon,
		IconColor = Config.IconColor,
		IconShape = Config.IconShape,
		IconThemed = Config.IconThemed,
		Locked = Config.Locked,
		ShowTabTitle = Config.ShowTabTitle,
		TabTitleAlign = Config.TabTitleAlign or "Left",
		CustomEmptyPage = (Config.CustomEmptyPage and next(Config.CustomEmptyPage) ~= nil) and Config.CustomEmptyPage
			or { Icon = "lucide:frown", IconSize = 48, Title = "This tab is Empty", Desc = nil },
		Border = Config.Border,
		Selected = false,
		Hovering = false,
		Pressed = false,
		Index = nil,
		Parent = Config.Parent,
		UIElements = {},
		Elements = {},
		ContainerFrame = nil,
		UICorner = Window.SidebarTabRadius or (Window.UICorner - (Window.UIPadding / 2)),

		Gap = Window.Layout == "Dashboard" and 10 or (Window.NewElements and 1 or 6),

		TabPaddingX = 4 + (Window.UIPadding / 2),
		TabPaddingY = 3 + (Window.UIPadding / 2),
		TitlePaddingY = 0,
	}

	-- Rail geometry flags. IconOnly drops the label so the rail can be a narrow
	-- icon column; Segmented butts tabs together into one connected control; a Top
	-- rail lays tabs horizontally and hugs each label instead of filling the width.
	-- The pre-rail values are kept so a runtime Type change can restore them.
	Tab.BaseUICorner = Tab.UICorner
	local IsTopRail = Window.SidebarIsTop == true
	local IconOnly = Window.SidebarIconOnly == true and not Tab.IconShape and Tab.Icon ~= nil
	Tab.IconOnly = IconOnly
	Tab.IsTopRail = IsTopRail

	-- if Tab.TabTitleAlign == "Left" then
	-- 	Tab.TabTitleAlign = "Top"
	-- elseif Tab.TabTitleAlign == "Right" then
	-- 	Tab.TabTitleAlign = "Bottom"
	-- elseif Tab.TabTitleAlign == "Center" then
	-- 	Tab.TabTitleAlign = "Center"
	-- end

	if Tab.IconShape then
		Tab.TabPaddingX = 2 + (Window.UIPadding / 4)
		Tab.TabPaddingY = 2 + (Window.UIPadding / 4)
		Tab.TitlePaddingY = 2 + (Window.UIPadding / 4)
	end
	Tab.BaseTabPaddingX = Tab.TabPaddingX

	TabModule.TabCount = TabModule.TabCount + 1

	local TabIndex = TabModule.TabCount
	Tab.Index = TabIndex

	local OutlineInstance, OutlineShape = Creator.NewRoundFrame(Tab.UICorner - 1, "Glass-1.4", {
		Size = UDim2.new(1, 1, 1, 1),
		ThemeTag = {
			ImageColor3 = "TabBorder",
		},
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		ImageTransparency = 1, -- .7
		Name = "Outline",
	}, {
		-- New("UIGradient", {
		--     Rotation = 80,
		--     Color = ColorSequence.new({
		--         ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
		--         ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		--         ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
		--     }),
		--     Transparency = NumberSequence.new({
		--         NumberSequenceKeypoint.new(0.0, 0.1),
		--         NumberSequenceKeypoint.new(0.5, 1),
		--         NumberSequenceKeypoint.new(1.0, 0.1),
		--     })
		-- }),
	})

	local MainInstance, MainShape = Creator.NewRoundFrame(Tab.UICorner, "Squircle", {
		BackgroundTransparency = 1,
		Parent = Config.Parent,
		ThemeTag = {
			ImageColor3 = "TabBackground",
		},
		ImageTransparency = 1,
	}, {
		OutlineInstance,
		Creator.NewRoundFrame(Tab.UICorner, "Squircle", {
			-- A Top rail sizes the whole tab from its content, so the label frame must take
			-- its width from the text rather than scale-1 of the tab (which is circular).
			Size = IsTopRail and UDim2.new(0, 0, 1, 0) or UDim2.new(1, 0, Window.SidebarTabHeight and 1 or 0, 0),
			AutomaticSize = IsTopRail and "X" or (Window.SidebarTabHeight and "None" or "Y"),
			ThemeTag = {
				ImageColor3 = "Text",
			},
			ImageTransparency = 1, -- .95
			Name = "Frame",
		}, {
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, IconOnly and 0 or 2 + (Window.UIPadding / 2)),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				HorizontalAlignment = IconOnly and "Center" or "Left",
			}),
			New("TextLabel", {
				Text = Tab.Title,
				ThemeTag = {
					TextColor3 = "TabTitle",
				},
				TextTransparency = not Tab.Locked and 0.4 or 0.7,
				TextSize = 15,
				Size = IsTopRail and UDim2.new(0, 0, 1, 0) or UDim2.new(1, 0, 0, 0),
				Visible = not IconOnly,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				TextWrapped = not IsTopRail,
				RichText = true,
				AutomaticSize = IsTopRail and "X" or "Y",
				LayoutOrder = 2,
				TextXAlignment = "Left",
				BackgroundTransparency = 1,
			}, {
				New("UIPadding", {
					PaddingTop = UDim.new(0, Tab.TitlePaddingY),
					--PaddingLeft = UDim.new(0,2+(Window.UIPadding/2)),
					--PaddingRight = UDim.new(0,2+(Window.UIPadding/2)),
					PaddingBottom = UDim.new(0, Tab.TitlePaddingY),
				}),
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, Tab.TabPaddingY),
				PaddingLeft = UDim.new(0, IsTopRail and 12 or Tab.TabPaddingX),
				PaddingRight = UDim.new(0, IsTopRail and 12 or Tab.TabPaddingX),
				PaddingBottom = UDim.new(0, Tab.TabPaddingY),
			}),
		}),
	}, true)
	Tab.UIElements.Main = MainInstance
	Tab.UIElements.MainShape = MainShape
	Tab.UIElements.OutlineShape = OutlineShape

	local TextOffset = 0
	local Icon
	local Icon2

	local TabIconSize = Window.SidebarIconSize or 20

	if Tab.Icon then
		Icon = Creator.Image(
			Tab.Icon,
			Tab.Icon .. ":" .. Tab.Title,
			0,
			Window.Folder,
			Tab.__type,
			Tab.IconColor and false or true,
			Tab.IconThemed,
			"TabIcon"
		)
		Icon.Size = UDim2.new(0, TabIconSize, 0, TabIconSize)
		if Tab.IconColor then
			Icon.ImageLabel.ImageColor3 = Tab.IconColor
		end
		if not Tab.IconShape then
			Icon.Parent = Tab.UIElements.Main.Frame
			Tab.UIElements.Icon = Icon
			Icon.ImageLabel.ImageTransparency = not Tab.Locked and 0 or 0.7
			TextOffset = -TabIconSize - 2 - (Window.UIPadding / 2)
			Tab.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1, TextOffset, 0, 0)
		elseif Tab.IconColor then
			local _IconBG = Creator.NewRoundFrame(
				Tab.IconShape ~= "Circle" and (Tab.UICorner + 5 - (2 + (Window.UIPadding / 4))) or 9999,
				"Squircle",
				{
					Size = UDim2.new(0, 26, 0, 26),
					ImageColor3 = Tab.IconColor,
					Parent = Tab.UIElements.Main.Frame,
				},
				{
					Icon,
					Creator.NewRoundFrame(
						Tab.IconShape ~= "Circle" and (Tab.UICorner + 5 - (2 + (Window.UIPadding / 4))) or 9999,
						"Glass-1.4",
						{
							Size = UDim2.new(1, 0, 1, 0),
							ThemeTag = {
								ImageColor3 = "White",
							},
							ImageTransparency = 0,
							Name = "Outline",
						},
						{
							-- New("UIGradient", {
							--     Rotation = 45,
							--     Color = ColorSequence.new({
							--         ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
							--         ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
							--         ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
							--     }),
							--     Transparency = NumberSequence.new({
							--         NumberSequenceKeypoint.new(0.0, 0.1),
							--         NumberSequenceKeypoint.new(0.5, 1),
							--         NumberSequenceKeypoint.new(1.0, 0.1),
							--     })
							-- }),
						}
					),
				}
			)
			Icon.AnchorPoint = Vector2.new(0.5, 0.5)
			Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
			Icon.ImageLabel.ImageTransparency = 0
			Icon.ImageLabel.ImageColor3 = Creator.GetTextColorForHSB(Tab.IconColor, 0.68)
			TextOffset = -26 - 2 - (Window.UIPadding / 2)
			Tab.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1, TextOffset, 0, 0)
		end

		Icon2 =
			Creator.Image(Tab.Icon, Tab.Icon .. ":" .. Tab.Title, 0, Window.Folder, Tab.__type, true, Tab.IconThemed)
		Icon2.Size = UDim2.new(0, TabIconSize, 0, TabIconSize)
		Icon2.ImageLabel.ImageTransparency = not Tab.Locked and 0 or 0.7
		TextOffset = -30

		--Icon2.Parent = Tab.UIElements.Main.Frame
		--Tab.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1,-30,0,0)
		--Tab.UIElements.Icon = Icon
	end

	local DashboardColumns
	local DashboardHeader
	local ContainerFrameChildren = {
		New("UIPadding", {
			PaddingTop = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
			PaddingLeft = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
			PaddingRight = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
			PaddingBottom = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
		}),
		New("UIListLayout", {
			SortOrder = "LayoutOrder",
			Padding = UDim.new(0, Tab.Gap),
			HorizontalAlignment = "Center",
		}),
	}

	if Window.Layout == "Dashboard" then
		local ColumnGap = 12
		DashboardHeader = New("Frame", {
			Name = "DashboardHeader",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Visible = false,
			LayoutOrder = 1,
		}, {
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, Tab.Gap),
				FillDirection = "Vertical",
				HorizontalAlignment = "Center",
				VerticalAlignment = "Top",
			}),
		})

		local function CreateDashboardColumn(Name)
			return New("Frame", {
				Name = Name,
				Size = UDim2.new(0.5, -ColumnGap / 2, 0, 0),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
			}, {
				New("UIListLayout", {
					SortOrder = "LayoutOrder",
					Padding = UDim.new(0, Tab.Gap),
					FillDirection = "Vertical",
					HorizontalAlignment = "Center",
					VerticalAlignment = "Top",
				}),
			})
		end

		local ColumnOne = CreateDashboardColumn("DashboardColumnOne")
		local ColumnTwo = CreateDashboardColumn("DashboardColumnTwo")
		DashboardColumns = { ColumnOne, ColumnTwo }
		local DashboardColumnsFrame = New("Frame", {
			Name = "DashboardColumnsFrame",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			LayoutOrder = 2,
		}, {
			ColumnOne,
			ColumnTwo,
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, ColumnGap),
				FillDirection = "Horizontal",
				HorizontalAlignment = "Center",
				VerticalAlignment = "Top",
			}),
		})
		local DashboardRoot = New("Frame", {
			Name = "DashboardRoot",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			LayoutOrder = 1,
		}, {
			DashboardHeader,
			DashboardColumnsFrame,
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, Tab.Gap),
				FillDirection = "Vertical",
				HorizontalAlignment = "Center",
				VerticalAlignment = "Top",
			}),
		})
		table.insert(ContainerFrameChildren, DashboardRoot)
		Tab.UIElements.DashboardHeader = DashboardHeader
		Tab.UIElements.DashboardColumns = DashboardColumns
		Tab.UIElements.DashboardElementCount = 0
		Tab.UIElements.DashboardRoot = DashboardRoot
	end

	Tab.UIElements.ContainerFrame = New("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, Tab.ShowTabTitle and -((Window.UIPadding * 2.4) + 12) or 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ElasticBehavior = "Never",
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		AutomaticCanvasSize = "Y",
		--Visible = false,
		ScrollingDirection = "Y",
	}, ContainerFrameChildren)

	-- Tab.UIElements.ContainerFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	--     Tab.UIElements.ContainerFrame.CanvasSize = UDim2.new(0,0,0,Tab.UIElements.ContainerFrame.UIListLayout.AbsoluteContentSize.Y+Window.UIPadding*2)
	-- end)

	Tab.UIElements.ContainerFrameCanvas = New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = Window.UIElements.MainBar,
		ZIndex = 5,
	}, {
		Tab.UIElements.ContainerFrame,
		New("Frame", {
			Size = UDim2.new(1, -14, 1, -14),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Name = "ScrollSliderHolder",
		}),
		New("Frame", {
			Size = UDim2.new(1, 0, 0, ((Window.UIPadding * 2.4) + 12)),
			BackgroundTransparency = 1,
			Visible = Tab.ShowTabTitle or false,
			Name = "TabTitle",
		}, {
			Icon2,
			New("TextLabel", {
				Text = Tab.Title,
				ThemeTag = {
					TextColor3 = "Text",
				},
				TextSize = 20,
				TextTransparency = 0.1,
				Size = UDim2.new(0, 0, 1, 0),
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				--TextTruncate = "AtEnd",
				RichText = true,
				LayoutOrder = 2,
				TextXAlignment = "Left",
				BackgroundTransparency = 1,
				AutomaticSize = "X",
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, 20),
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20),
				PaddingBottom = UDim.new(0, 20),
			}),
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, 10),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				HorizontalAlignment = Tab.TabTitleAlign,
			}),
		}),
		New("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundTransparency = 0.9,
			ThemeTag = {
				BackgroundColor3 = "Text",
			},
			Position = UDim2.new(0, 0, 0, ((Window.UIPadding * 2.4) + 12)),
			Visible = Tab.ShowTabTitle or false,
		}),
	})

	TabModule.Containers[TabIndex] = Tab.UIElements.ContainerFrameCanvas
	TabModule.Tabs[TabIndex] = Tab

	Tab.ContainerFrame = Tab.UIElements.ContainerFrameCanvas

	Creator.AddSignal(Tab.UIElements.Main.MouseButton1Click, function()
		if not Tab.Locked then
			TabModule:SelectTab(TabIndex)
		end
	end)

	if Window.ScrollBarEnabled then
		CreateScrollSlider(
			Tab.UIElements.ContainerFrame,
			Tab.UIElements.ContainerFrameCanvas.ScrollSliderHolder,
			Window,
			4,
			NevaUI
		)
	end

	local ToolTip
	local hoverTimer
	local MouseConn
	local IsHovering = false

	-- ToolTip. An icon-only rail hides the label, so fall back to the tab title to
	-- keep the tab identifiable on hover. The text is resolved per hover because the
	-- rail Type can change after the tab is created.
	local function GetTooltipText()
		if Tab.IconOnly then
			return Tab.Desc or Tab.Title
		end
		return Tab.Desc
	end

	Creator.AddSignal(Tab.UIElements.Main.InputBegan, function()
		if not GetTooltipText() then
			return
		end
		IsHovering = true
		hoverTimer = task.spawn(function()
			task.wait(0.35)
			local TooltipText = GetTooltipText()
			if IsHovering and not ToolTip and TooltipText then
				ToolTip = CreateToolTip(TooltipText, TabModule.ToolTipParent, true)
				ToolTip.Container.AnchorPoint = Vector2.new(0.5, 0.5)

				local function updatePosition()
					if ToolTip then
						ToolTip.Container.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y - 4)
					end
				end

				updatePosition()
				MouseConn = Mouse.Move:Connect(updatePosition)
				ToolTip:Open()
			end
		end)
	end)

	-- Tabs share one state machine (idle/hover/pressed, selected or not) so the
	-- background, label and icon always agree. Driving them from a single place
	-- also fixes the old bug where hovering a tab and moving away left it lit,
	-- because only InputEnded (not MouseLeave) restored the idle look.
	local TabStateTokens = {
		idle = {
			Background = "TabBackground",
			BackgroundTransparency = "TabBackgroundTransparency",
			TextTransparency = "TabTextTransparency",
			IconTransparency = "TabIconTransparency",
			BorderTransparency = "TabBorderTransparency",
		},
		hover = {
			Background = "TabBackgroundHover",
			BackgroundTransparency = "TabBackgroundHoverTransparency",
			TextTransparency = "TabTextTransparencyHover",
			IconTransparency = "TabIconTransparencyHover",
			BorderTransparency = "TabBorderTransparencyHover",
		},
		pressed = {
			Background = "TabBackgroundPressed",
			BackgroundTransparency = "TabBackgroundPressedTransparency",
			TextTransparency = "TabTextTransparencyActive",
			IconTransparency = "TabIconTransparencyActive",
			BorderTransparency = "TabBorderTransparencyActive",
		},
		active = {
			Background = "TabBackgroundActive",
			BackgroundTransparency = "TabBackgroundActiveTransparency",
			TextTransparency = "TabTextTransparencyActive",
			IconTransparency = "TabIconTransparencyActive",
			BorderTransparency = "TabBorderTransparencyActive",
		},
		activeHover = {
			Background = "TabBackgroundActiveHover",
			BackgroundTransparency = "TabBackgroundActiveHoverTransparency",
			TextTransparency = "TabTextTransparencyActive",
			IconTransparency = "TabIconTransparencyActive",
			BorderTransparency = "TabBorderTransparencyActive",
		},
		activePressed = {
			Background = "TabBackgroundActivePressed",
			BackgroundTransparency = "TabBackgroundActivePressedTransparency",
			TextTransparency = "TabTextTransparencyActive",
			IconTransparency = "TabIconTransparencyActive",
			BorderTransparency = "TabBorderTransparencyActive",
		},
	}

	local function ApplyTabState(Duration)
		if Tab.Locked then
			return
		end
		local State = "idle"
		if Tab.Selected then
			State = Tab.Pressed and "activePressed" or (Tab.Hovering and "activeHover" or "active")
		elseif Tab.Pressed then
			State = "pressed"
		elseif Tab.Hovering then
			State = "hover"
		end
		local Tokens = TabStateTokens[State]
		Creator.SetThemeTag(Tab.UIElements.Main, {
			ImageColor3 = Tokens.Background,
			ImageTransparency = Tokens.BackgroundTransparency,
		}, Duration or 0.12)
		if Tab.Border and Tab.UIElements.Main.Outline then
			Creator.SetThemeTag(Tab.UIElements.Main.Outline, {
				ImageTransparency = Tokens.BorderTransparency,
			}, Duration or 0.12)
		end
		Creator.SetThemeTag(Tab.UIElements.Main.Frame.TextLabel, {
			TextTransparency = Tokens.TextTransparency,
		}, Duration or 0.12)
		if Tab.UIElements.Icon and not Tab.IconColor then
			Creator.SetThemeTag(Tab.UIElements.Icon.ImageLabel, {
				ImageTransparency = Tokens.IconTransparency,
			}, Duration or 0.12)
		end
	end

	-- Expose the applier so SelectTab can refresh every tab through the same path.
	Tab.RefreshState = ApplyTabState

	local function ClearTooltip()
		IsHovering = false
		if hoverTimer then
			task.cancel(hoverTimer)
			hoverTimer = nil
		end
		if MouseConn then
			MouseConn:Disconnect()
			MouseConn = nil
		end
		if ToolTip then
			ToolTip:Close()
			ToolTip = nil
		end
	end

	Creator.AddSignal(Tab.UIElements.Main.MouseEnter, function()
		Tab.Hovering = true
		ApplyTabState()
	end)
	Creator.AddSignal(Tab.UIElements.Main.MouseLeave, function()
		Tab.Hovering = false
		Tab.Pressed = false
		ApplyTabState()
		ClearTooltip()
	end)
	Creator.AddSignal(Tab.UIElements.Main.MouseButton1Down, function()
		Tab.Pressed = true
		ApplyTabState(0.08)
	end)
	Creator.AddSignal(Tab.UIElements.Main.MouseButton1Up, function()
		Tab.Pressed = false
		ApplyTabState(0.08)
	end)
	Creator.AddSignal(Tab.UIElements.Main.InputEnded, function()
		Tab.Pressed = false
		ApplyTabState()
		ClearTooltip()
	end)

	-- The icon branches reserve label width by shrinking the label. Remember the inset
	-- they applied so a rail relayout re-applies it instead of letting the label run
	-- under the icon.
	Tab.TextOffset = Tab.UIElements.Main.Frame.TextLabel.Size.X.Offset

	-- Recompute every rail-dependent measurement. Runs at build time and again
	-- whenever the window changes Sidebar.Position or Sidebar.Type.
	function Tab:ApplyRailLayout()
		local IsTop = Window.SidebarIsTop == true
		local Segmented = Window.SidebarType == "Segmented"
		-- An icon-only rail needs an icon to stay usable, so fall back to a labelled
		-- tab when the config did not supply one.
		local IconOnlyNow = Window.SidebarIconOnly == true and not Tab.IconShape and Tab.Icon ~= nil
		Tab.IconOnly = IconOnlyNow
		Tab.IsTopRail = IsTop

		local Main = Tab.UIElements.Main
		local LabelFrame = Main and Main:FindFirstChild("Frame")
		local TextLabel = LabelFrame and LabelFrame:FindFirstChild("TextLabel")
		local List = LabelFrame and LabelFrame:FindFirstChild("UIListLayout")
		local LabelPadding = LabelFrame and LabelFrame:FindFirstChild("UIPadding")
		local TabList = Window.UIElements.SideBar.Frame
		local TabListLayout = TabList and TabList:FindFirstChild("UIListLayout")
		local TabListPadding = TabList and TabList:FindFirstChild("UIPadding")

		if TabListLayout then
			TabListLayout.FillDirection = IsTop and "Horizontal" or "Vertical"
		end
		if TabListPadding then
			TabListPadding.PaddingRight = UDim.new(0, IsTop and Window.SidebarGap or Window.SidebarPadding)
			TabListPadding.PaddingBottom = UDim.new(0, IsTop and 0 or Window.UIPadding / 2)
		end

		-- The rail Type owns the corner radius: Segmented softens it, otherwise the
		-- base radius applies. Re-apply it to the live shapes because they cache the
		-- value they were built with.
		local RailCorner = Segmented and math.min(Tab.BaseUICorner, 8) or Tab.BaseUICorner
		Tab.UICorner = RailCorner
		if Tab.UIElements.MainShape then
			Tab.UIElements.MainShape:SetRadius(RailCorner)
		end
		if Tab.UIElements.OutlineShape then
			Tab.UIElements.OutlineShape:SetRadius(RailCorner - 1)
		end

		local SidebarTabHeight = Window.SidebarTabHeight

		if not Main then
			return
		end

		if IsTop then
			Main.Size = UDim2.new(0, 0, 1, 0)
			Main.AutomaticSize = "X"
		elseif IconOnlyNow then
			local IconButtonSize = SidebarTabHeight or 38
			Main.Size = UDim2.new(0, IconButtonSize, 0, IconButtonSize)
			Main.AutomaticSize = "None"
		elseif SidebarTabHeight then
			Main.Size = UDim2.new(1, Segmented and -4 or -7, 0, SidebarTabHeight)
			Main.AutomaticSize = "None"
		else
			Main.Size = UDim2.new(1, Segmented and -4 or -7, 0, 0)
			Main.AutomaticSize = "Y"
		end

		if LabelFrame then
			LabelFrame.Size = IsTop and UDim2.new(0, 0, 1, 0)
				or UDim2.new(1, 0, SidebarTabHeight and 1 or 0, 0)
			LabelFrame.AutomaticSize = IsTop and "X" or (SidebarTabHeight and "None" or "Y")
		end
		if List then
			List.Padding = UDim.new(0, IconOnlyNow and 0 or 2 + (Window.UIPadding / 2))
			List.HorizontalAlignment = IconOnlyNow and "Center" or "Left"
		end
		if LabelPadding then
			-- An icon-only rail has no label, so the only inset is the icon centering.
			local LabelInset = IconOnlyNow and 0 or (IsTop and 12 or Tab.BaseTabPaddingX)
			LabelPadding.PaddingLeft = UDim.new(0, LabelInset)
			LabelPadding.PaddingRight = UDim.new(0, LabelInset)
		end
		if TextLabel then
			-- A Top rail lets automatic sizing place the label after the icon inside the
			-- horizontal list; a vertical tab keeps the inset the icon reserved.
			TextLabel.Size = IsTop and UDim2.new(0, 0, 1, 0) or UDim2.new(1, Tab.TextOffset or 0, 0, 0)
			TextLabel.AutomaticSize = IsTop and "X" or "Y"
			TextLabel.TextWrapped = not IsTop
			TextLabel.Visible = not IconOnlyNow
		end
	end

	-- Run once at build time so a tab created before any rail change still matches
	-- the current Sidebar.Position / Sidebar.Type.
	Tab:ApplyRailLayout()

	-- Render the initial (idle) look through the same path so a freshly created
	-- tab already matches the theme instead of the hardcoded starting values.
	ApplyTabState(0)

	function Tab:ScrollToTheElement(elemindex)
		Tab.UIElements.ContainerFrame.ScrollingEnabled = false

		Creator.Tween(Tab.UIElements.ContainerFrame, 0.45, {
			CanvasPosition = Vector2.new(
				0,
				Tab.Elements[elemindex].ElementFrame.AbsolutePosition.Y
					- Tab.UIElements.ContainerFrame.AbsolutePosition.Y
					- Tab.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
			),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		task.spawn(function()
			task.wait(0.48)

			if Tab.Elements[elemindex].Highlight then
				Tab.Elements[elemindex]:Highlight()
			end
			Tab.UIElements.ContainerFrame.ScrollingEnabled = true
		end)

		return Tab
	end

	-- yo

	local ElementsModule = require("../../elements/Init")

	ElementsModule.Load(
		Tab,
		Tab.UIElements.ContainerFrame,
		ElementsModule.Elements,
		Window,
		NevaUI,
		nil,
		ElementsModule,
		UIScale,
		Tab
	)

	function Tab:LockAll()
		--print("LockAll called, number of elements: " .. #self.Elements)
		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Lock then
				element:Lock()
			end
		end
	end
	function Tab:UnlockAll()
		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Unlock then
				element:Unlock()
			end
		end
	end
	function Tab:GetLocked()
		local LockedElements = {}

		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Locked == true then
				table.insert(LockedElements, element)
			end
		end

		return LockedElements
	end
	function Tab:GetUnlocked()
		local UnlockedElements = {}

		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Locked == false then
				table.insert(UnlockedElements, element)
			end
		end

		return UnlockedElements
	end

	function Tab:Select()
		return TabModule:SelectTab(Tab.Index)
	end

	task.spawn(function()
		local EmptyPageIcon
		if Tab.CustomEmptyPage.Icon then
			EmptyPageIcon =
				Creator.Image(Tab.CustomEmptyPage.Icon, Tab.CustomEmptyPage.Icon, 0, "Temp", "EmptyPage", true)
			EmptyPageIcon.Size =
				UDim2.fromOffset(Tab.CustomEmptyPage.IconSize or 48, Tab.CustomEmptyPage.IconSize or 48)
		end

		local Empty = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
			LayoutOrder = 0,
			Parent = Tab.UIElements.ContainerFrame,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 8),
				SortOrder = "LayoutOrder",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Center",
				FillDirection = "Vertical",
			}),
			-- New("ImageLabel", {
			-- 	Size = UDim2.new(0, 48, 0, 48),
			-- 	Image = Creator.Icon("frown")[1],
			-- 	ImageRectOffset = Creator.Icon("frown")[2].ImageRectPosition,
			-- 	ImageRectSize = Creator.Icon("frown")[2].ImageRectSize,
			-- 	ThemeTag = {
			-- 		ImageColor3 = "Icon",
			-- 	},
			-- 	BackgroundTransparency = 1,
			-- 	ImageTransparency = 0.6,
			-- }),
			EmptyPageIcon,
			Tab.CustomEmptyPage.Title and New("TextLabel", { -- Title
				AutomaticSize = "XY",
				Text = Tab.CustomEmptyPage.Title,
				ThemeTag = {
					TextColor3 = "Text",
				},
				TextSize = 18,
				TextTransparency = 0.5,
				BackgroundTransparency = 1,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			}) or nil,
			Tab.CustomEmptyPage.Desc and New("TextLabel", { -- Desc
				AutomaticSize = "XY",
				Text = Tab.CustomEmptyPage.Desc,
				ThemeTag = {
					TextColor3 = "Text",
				},
				TextSize = 15,
				TextTransparency = 0.65,
				BackgroundTransparency = 1,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
			}) or nil,
		})

		-- Empty.TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
		--     Empty.TextLabel.Size = UDim2.new(0,Empty.TextLabel.TextBounds.X,0,Empty.TextLabel.TextBounds.Y)
		-- end)

		local CreationConnections = {}
		local function HideEmptyPage()
			if not Empty.Visible then
				return
			end
			Empty.Visible = false
			for _, connection in ipairs(CreationConnections) do
				connection:Disconnect()
			end
		end
		local EmptyPageParents = Tab.UIElements.DashboardColumns or { Tab.UIElements.ContainerFrame }
		for _, parent in ipairs(EmptyPageParents) do
			table.insert(CreationConnections, Creator.AddSignal(parent.ChildAdded, HideEmptyPage))
		end
		if #Tab.Elements > 0 then
			HideEmptyPage()
		end
	end)

	return Tab
end

function TabModule:OnChange(func)
	TabModule.OnChangeFunc = func
end

-- Rebuild every tab for the current rail axis. The window calls this after it
-- changes Sidebar.Position or Sidebar.Type at runtime.
function TabModule:ApplyRailLayout()
	for _, TabObject in next, TabModule.Tabs do
		if TabObject.ApplyRailLayout then
			local ok, err = pcall(function()
				TabObject:ApplyRailLayout()
			end)
			if not ok then
				warn("[ NevaUI.Tab ] Failed to relayout tab: " .. tostring(err))
			end
		end
	end
	if TabModule.SelectedTab and TabModule.Tabs[TabModule.SelectedTab] then
		TabModule.OnSelectorTargetFunc(TabModule.Tabs[TabModule.SelectedTab])
	end
end

function TabModule:SelectTab(TabIndex)
	local Target = TabModule.Tabs[TabIndex]
	if Target and not Target.Locked then
		TabModule.SelectedTab = TabIndex

		-- Flip the selection flags first, then let every tab re-render itself
		-- through the shared state machine so idle, hover and active agree.
		for _, TabObject in next, TabModule.Tabs do
			TabObject.Selected = TabObject == Target
		end
		for _, TabObject in next, TabModule.Tabs do
			if TabObject.RefreshState then
				TabObject.RefreshState(0.15)
			end
		end

		task.spawn(function()
			for _, ContainerObject in next, TabModule.Containers do
				ContainerObject.AnchorPoint = Vector2.new(0, 0.05)
				ContainerObject.Visible = false
			end
			TabModule.Containers[TabIndex].Visible = true
			local TweenService = game:GetService("TweenService")

			local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			local tween = TweenService:Create(TabModule.Containers[TabIndex], tweenInfo, {
				AnchorPoint = Vector2.new(0, 0),
			})
			tween:Play()
		end)

		TabModule.OnChangeFunc(TabIndex)
		TabModule.OnSelectorTargetFunc(TabModule.Tabs[TabIndex])
	end
end

return TabModule
