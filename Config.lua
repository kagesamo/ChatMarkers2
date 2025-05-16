-- Garante que a tabela de configuração existe
ChatMarkersConfig = ChatMarkersConfig or {
    tooltip_delay = 0.8,
    tooltip_size = 0.8,
    max_history = 50,
}

-- ========================
-- Aplicar configurações manualmente
-- ========================

local function ApplyConfig()
    if ChatMarkersTooltip then
        ChatMarkersTooltip:SetScale(ChatMarkersConfig.tooltip_size or 0.8)
    end

    if ChatMarkersHistory then
        local max = ChatMarkersConfig.max_history or 50
        while #ChatMarkersHistory > max do
            table.remove(ChatMarkersHistory)
        end
    end
end

-- ========================
-- Registo das definições
-- ========================

local category = Settings.RegisterVerticalLayoutCategory("ChatMarkers2")

do
    local setting = Settings.RegisterAddOnSetting(
        category,
        "tooltip_delay",
        "tooltip_delay",
        ChatMarkersConfig,
        Settings.VarType.Number,
        "Atraso do Tooltip",
        0.8
    )
    local tooltip = "Tempo de atraso para mostrar o tooltip (em segundos)."
    local options = Settings.CreateSliderOptions(0.0, 2.0, 0.1)
    Settings.CreateSlider(category, setting, options, tooltip)
end

do
    local setting = Settings.RegisterAddOnSetting(
        category,
        "tooltip_size",
        "tooltip_size",
        ChatMarkersConfig,
        Settings.VarType.Number,
        "Tamanho do Tooltip",
        0.8
    )
    local tooltip = "Escala do tooltip (0.5 a 1.5)."
    local options = Settings.CreateSliderOptions(0.5, 1.5, 0.05)
    Settings.CreateSlider(category, setting, options, tooltip)
end

do
    local setting = Settings.RegisterAddOnSetting(
        category,
        "max_history",
        "max_history",
        ChatMarkersConfig,
        Settings.VarType.Number,
        "Tamanho do Histórico",
        50
    )
    local tooltip = "Número máximo de entradas no histórico."
    local options = Settings.CreateSliderOptions(10, 500, 1)
    Settings.CreateSlider(category, setting, options, tooltip)
end

Settings.RegisterAddOnCategory(category)

-- ========================
-- Aplicar no carregamento
-- ========================

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, addonName)
    if addonName == "ChatMarkers2" then
        ApplyConfig()
    end
end)
