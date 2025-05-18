-- ========================
-- Configurações do ChatMarkers2
-- ========================

ChatMarkersConfig = ChatMarkersConfig or {
    tooltip_delay = 0.8,
    tooltip_size = 0.8,
    max_history = 50,
    enable_tooltips = true,
}


--[[
local category = Settings.RegisterVerticalLayoutCategory("ChatMarkers2")

local function OnSettingChanged(setting, value)
    print("Setting changed:", setting:GetVariable(), value)
end

-- === Função auxiliar unificada ===
local function CreateSetting(params)
    local setting = Settings.RegisterAddOnSetting(
        category,
        params.variable,
        params.key,
        ChatMarkersConfig,
        type(params.default),
        params.name,
        params.default
    )
    setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = params.tooltip or ""

    if type(params.default) == "number" and params.min then
        local options = Settings.CreateSliderOptions(params.min, params.max, params.step or 1)
        if params.formatter then
            options:SetLabelFormatter(params.formatter)
        end
        Settings.CreateSlider(category, setting, options, tooltip)

    elseif type(params.default) == "boolean" then
        Settings.CreateCheckbox(category, setting, tooltip)

    elseif type(params.default) == "string" and params.values then
        -- Dropdown
        local options = Settings.CreateDropDownOptions()
        for _, v in ipairs(params.values) do
            options:Add(v.value, v.name)
        end
        Settings.CreateDropDown(category, setting, options, tooltip)

    elseif type(params.default) == "string" then
        -- Text input
        Settings.CreateInput(category, setting, tooltip)
    end
end

-- === Sliders ===
CreateSetting{
    variable = "ChatMarkers2_TooltipDelay",
    key = "tooltip_delay",
    name = "Atraso do Tooltip",
    default = 0.8,
    min = 0.0,
    max = 2.0,
    step = 0.1,
    tooltip = "Tempo em segundos até o tooltip aparecer."
}

CreateSetting{
    variable = "ChatMarkers2_TooltipSize",
    key = "tooltip_size",
    name = "Tamanho do Tooltip",
    default = 0.8,
    min = 0.5,
    max = 1.5,
    step = 0.05,
    tooltip = "Escala do tooltip (de 0.5 a 1.5)."
}

CreateSetting{
    variable = "ChatMarkers2_HistorySize",
    key = "max_history",
    name = "Tamanho do Histórico",
    default = 50,
    min = 10,
    max = 500,
    step = 1,
    tooltip = "Número máximo de entradas no histórico."
}

-- === Checkbox ===
CreateSetting{
    variable = "ChatMarkers2_EnableTooltips",
    key = "enable_tooltips",
    name = "Ativar Tooltips",
    default = true,
    tooltip = "Ativa ou desativa os tooltips nos botões."
}

-- Registar categoria
Settings.RegisterAddOnCategory(category)

----------------------
----------------------

-- === Dropdown ===
CreateSetting{
    variable = "ChatMarkers2_MarkerStyle",
    key = "marker_style",
    name = "Estilo dos Marcadores",
    default = "classic",
    tooltip = "Escolha o estilo visual dos marcadores.",
    values = {
        {value = "classic", name = "Clássico"},
        {value = "modern", name = "Moderno"},
        {value = "minimal", name = "Minimalista"},
    }
}

-- === Text input ===
CreateSetting{
    variable = "ChatMarkers2_CustomPrefix",
    key = "custom_prefix",
    name = "Prefixo Personalizado",
    default = "",
    tooltip = "Texto que será adicionado antes da mensagem enviada."
}
]]

--[[
Como usar no addon

if ChatMarkersConfig.enable_tooltips then
    -- Mostrar tooltip no botão, por exemplo
end

]]
