-- 3.3.5 APIs needed before LibUIDropDownMenuQuestie-4.0 creates frames.

if not SOUNDKIT then
	SOUNDKIT = {
		U_CHAT_SCROLL_BUTTON = "UChatScrollButton",
		IG_MAINMENU_OPTION_CHECKBOX_ON = "igMainMenuOptionCheckBoxOn",
	}
end

if not EventRegistry then
	EventRegistry = {
		TriggerEvent = function() end,
		RegisterCallback = function() end,
	}
end

if not GameTooltip_SetTitle then
	function GameTooltip_SetTitle(tooltip, title)
		tooltip:SetText(title, 1, 0.82, 0, 1)
	end
end

if not GameTooltip_AddInstructionLine then
	function GameTooltip_AddInstructionLine(tooltip, text)
		tooltip:AddLine(text, 0, 1, 0, 1)
	end
end

if not GameTooltip_AddNormalLine then
	function GameTooltip_AddNormalLine(tooltip, text, wrap)
		tooltip:AddLine(text, 1, 0.82, 0, wrap)
	end
end

if not GameTooltip_AddColoredLine then
	function GameTooltip_AddColoredLine(tooltip, text, color, wrap)
		local r, g, b = 1, 1, 1
		if type(color) == "table" then
			r, g, b = color.r or 1, color.g or 1, color.b or 1
		end
		tooltip:AddLine(text, r, g, b, wrap)
	end
end

local function ShimSetSize(obj)
	if not obj or obj.SetSize then
		return
	end
	local meta = getmetatable(obj)
	if not meta or type(meta.__index) ~= "table" or meta.__index.SetSize then
		return
	end
	function meta.__index:SetSize(width, height)
		self:SetWidth(width)
		self:SetHeight(height)
	end
end

local protoFrame = CreateFrame("Frame")
ShimSetSize(protoFrame)
ShimSetSize(protoFrame:CreateTexture())

local protoFont = protoFrame:CreateFontString()
if protoFont and not protoFont.SetWordWrap then
	local meta = getmetatable(protoFont)
	if meta and type(meta.__index) == "table" and not meta.__index.SetWordWrap then
		meta.__index.SetWordWrap = function() end
	end
end

local protoButton = CreateFrame("Button")
if protoButton and not protoButton.SetMotionScriptsWhileDisabled then
	local meta = getmetatable(protoButton)
	if meta and type(meta.__index) == "table" and not meta.__index.SetMotionScriptsWhileDisabled then
		meta.__index.SetMotionScriptsWhileDisabled = function() end
	end
end

if protoFrame and not protoFrame.IsMouseOver and MouseIsOver then
	local function IsMouseOver(self)
		return MouseIsOver(self)
	end
	local function MaybeAdd(obj)
		if not obj or obj.IsMouseOver then
			return
		end
		local meta = getmetatable(obj)
		if meta and type(meta.__index) == "table" and not meta.__index.IsMouseOver then
			meta.__index.IsMouseOver = IsMouseOver
		end
	end
	MaybeAdd(protoFrame)
	MaybeAdd(protoButton)
end
