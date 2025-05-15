-- Delay padrão para tooltips (em segundos)
TOOLTIP_DELAY = 0.8
TOOLTIP_SIZE = 0.8

MAX_HISTORY = 50
-- Tamanho padrão dos botões de marcador
--MARKER_BUTTON_SIZE = 30

-- Posição e tamanho da frame principal
--MAIN_FRAME_WIDTH = 300
--MAIN_FRAME_HEIGHT = 200

-- Cor de fundo da frame principal
--FRAME_BACKGROUND_COLOR = { r = 0, g = 0, b = 0, a = 0.8 }

--ChatMarkersConfig = ChatMarkersConfig or {enabled = true, scale = 1.0}

local category = Settings.RegisterVerticalLayoutCategory("ChatMarker")

local function OnSettingChanged(setting, value)
	print("Setting changed:", setting:GetVariable(), value)
end


local name = "Test Checkbox"
local variable = "ChatMarkersConfig_Toggle"
local variableKey = "toggle"
local variableTbl = ChatMarkersConfig
local defaultValue = true

--local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
local setting = Settings.RegisterAddOnSetting(category, "ChatMarkersConfig_Toggle", "toggle", ChatMarkersConfig, type(true), "Test Checkbox", true)
setting:SetValueChangedCallback(OnSettingChanged)

local tooltip = "This is a tooltip for the checkbox."
Settings.CreateCheckbox(category, setting, tooltip)


local minValue = 90
local maxValue = 360
local step = 10

local function GetValue()
	return ChatMarkersConfig.slider or 180
end

local function SetValue(value)
	ChatMarkersConfig.slider = value
end

local setting = Settings.RegisterProxySetting(category, "ChatMarkersConfig_Slider", type(180), "Test Slider", 180, GetValue, SetValue)
setting:SetValueChangedCallback(OnSettingChanged)

local tooltip = "This is a tooltip for the slider."
local options = Settings.CreateSliderOptions(minValue, maxValue, step)
options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
Settings.CreateSlider(category, setting, options, tooltip)


Settings.RegisterAddOnCategory(category)