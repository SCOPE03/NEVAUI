return {
	Elements = {
		Paragraph = require("./Paragraph"),
		Button = require("./Button"),
		Toggle = require("./Toggle"),
		Slider = require("./Slider"),
		ProgressBar = require("./ProgressBar"),
		Keybind = require("./Keybind"),
		Input = require("./Input"),
		Dropdown = require("./Dropdown"),
		Code = require("./Code"),
		Colorpicker = require("./Colorpicker"),
		Section = require("./Section"),
		Divider = require("./Divider"),
		Space = require("./Space"),
		Image = require("./Image"),
		Group = require("./Group"),
		HStack = require("./HStack"),
		VStack = require("./VStack"),
		Viewport = require("./Viewport"),
		--Video       = require("./Video"),
	},
	Load = function(tbl, Container, Elements, Window, NevaUI, OnElementCreateFunction, ElementsModule, UIScale, Tab)
		for name, module in next, Elements do
			tbl[name] = function(self, config)
				config = config or {}
				if config.Style ~= nil and config.Style ~= "Legacy" and config.Style ~= "Modern" then
					error('Invalid Style "' .. tostring(config.Style) .. '". Expected "Legacy" or "Modern".', 2)
				end
				config.NewElements = config.Style == "Modern" or (config.Style == nil and Window.NewElements == true)
				config.Tab = Tab or tbl
				config.ParentType = tbl.__type
				config.ParentTable = tbl
				config.Index = #tbl.Elements + 1
				config.GlobalIndex = #Window.AllElements + 1
				local ElementParent = Container
				if Window.Layout == "Dashboard" and Tab and tbl == Tab and Tab.UIElements.DashboardColumns then
					local columnIndex = ((#tbl.Elements) % #Tab.UIElements.DashboardColumns) + 1
					ElementParent = Tab.UIElements.DashboardColumns[columnIndex]
				end
				config.Parent = ElementParent
				config.Window = Window
				config.NevaUI = NevaUI
				config.UIScale = UIScale
				config.ElementsModule = ElementsModule

				local _elementInstance, content = module:New(config)

				if config.Flag and typeof(config.Flag) == "string" then
					if Window.CurrentConfig then
						Window.CurrentConfig:Register(config.Flag, content)

						if Window.PendingConfigData and Window.PendingConfigData[config.Flag] then
							local data = Window.PendingConfigData[config.Flag]

							local ConfigManager = Window.ConfigManager
							if ConfigManager.Parser[data.__type] then
								task.defer(function()
									local success, err = pcall(function()
										ConfigManager.Parser[data.__type].Load(content, data)
									end)

									if success then
										Window.PendingConfigData[config.Flag] = nil
									else
										warn(
											"[ NevaUI ] Failed to apply pending config for '"
												.. config.Flag
												.. "': "
												.. tostring(err)
										)
									end
								end)
							end
						end
					else
						Window.PendingFlags = Window.PendingFlags or {}
						Window.PendingFlags[config.Flag] = content
					end
				end

				local frame
				for key, value in next, content do
					if typeof(value) == "table" and key ~= "ElementFrame" and key:match("Frame$") then
						frame = value
						break
					end
				end

				if frame then
					content.ElementFrame = frame.UIElements.Main
					function content:SetTitle(title)
						return frame.SetTitle and frame:SetTitle(title)
					end
					function content:SetDesc(desc)
						return frame.SetDesc and frame:SetDesc(desc)
					end
					function content:SetImage(image, size)
						return frame.SetImage and frame:SetImage(image, size)
					end
					function content:SetThumbnail(image, size)
						return frame.SetThumbnail and frame:SetThumbnail(image, size)
					end
					function content:Highlight()
						frame:Highlight()
					end
					function content:Destroy()
						frame:Destroy()

						table.remove(Window.AllElements, config.GlobalIndex)
						table.remove(tbl.Elements, config.Index)
						table.remove(Tab.Elements, config.Index)
						tbl:UpdateAllElementShapes(tbl)
					end
				end

				Window.AllElements[config.Index] = content
				tbl.Elements[config.Index] = content
				if Tab then
					Tab.Elements[config.Index] = content
				end

				if config.NewElements then
					tbl:UpdateAllElementShapes(tbl)
				end

				if OnElementCreateFunction then
					OnElementCreateFunction(content, tbl.Elements)
				end
				return content
			end
		end
		function tbl:UpdateAllElementShapes(bbb)
			for i, element in next, bbb.Elements do
				local frame
				for key, value in pairs(element) do
					if typeof(value) == "table" and key:match("Frame$") then
						frame = value
						break
					end
				end

				if not frame and element.UpdateShape then
					frame = element
				end

				if frame then
					--print("idx changed : " .. i .. " " .. (element.Title or "not found"))
					frame.Index = i
					if frame.UpdateShape then
						--print(" .changed: " .. i)
						frame.UpdateShape(bbb)
					end
				end
			end
		end
	end,
}
