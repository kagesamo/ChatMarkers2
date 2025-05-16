ChatMarkersConfig = ChatMarkersConfig or {
    tooltip_delay = 0.8,
    tooltip_size = 0.8,
    max_history = 50,
}

local category = Settings.RegisterVerticalLayoutCategory("ChatMarkers2")

local function OnSettingChanged(setting, value)
	print("Setting changed:", setting:GetVariable(), value)
end

do
    local name = "Tooltip delay"
    local variable = "ChatMarkers2_TooltipDelay"
	local variableKey = "tooltip_delay"
	local variableTbl = ChatMarkersConfig
    local defaultValue = 0.8

    local setting = Settings.RegisterAddOnSetting(
        category,
        variable,
        variableKey,
        variableTbl,
        type(defaultValue),
        name,
        defaultValue
    )
	setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Tooltip delay in seconds."
    local options = Settings.CreateSliderOptions(0.0, 2.0, 0.1)
	Settings.CreateSlider(category, setting, options, tooltip)
end

do
    local name = "Tooltip size"
    local variable = "ChatMarkers2_TooltipSize"
	local variableKey = "tooltip_size"
	local variableTbl = ChatMarkersConfig
    local defaultValue = 0.8

    local setting = Settings.RegisterAddOnSetting(
        category,
        variable,
        variableKey,
        variableTbl,
        type(defaultValue),
        name,
        defaultValue
    )
	setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Tooltip size (0.5 a 1.5)."
    local options = Settings.CreateSliderOptions(0.5, 1.5, 0.05)
	Settings.CreateSlider(category, setting, options, tooltip)
end

do
    local name = "History size"
    local variable = "ChatMarkers2_HistorySize"
	local variableKey = "max_history"
	local variableTbl = ChatMarkersConfig
    local defaultValue = 50

    local setting = Settings.RegisterAddOnSetting(
        category,
        variable,
        variableKey,
        variableTbl,
        type(defaultValue),
        name,
        defaultValue
    )
	setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Número máximo de entradas no histórico."
    local options = Settings.CreateSliderOptions(10, 500, 1)
	Settings.CreateSlider(category, setting, options, tooltip)
end

Settings.RegisterAddOnCategory(category)

--[[
do
	-- RegisterProxySetting example. This will run the GetValue and SetValue
	-- callbacks whenever access to the setting is required.

	local name = "Test Slider"
	local variable = "MyAddOn_Slider"
    local defaultValue = 180
    local minValue = 90
    local maxValue = 360
    local step = 10

	local function GetValue()
		return MyAddOn_SavedVars.slider or defaultValue
	end

	local function SetValue(value)
		MyAddOn_SavedVars.slider = value
	end

	local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
	setting:SetValueChangedCallback(OnSettingChanged)

	local tooltip = "This is a tooltip for the slider."
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end
]]