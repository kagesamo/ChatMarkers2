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

--ChatMarkersConfig = ChatMarkersConfig or {tooltip_delay = 0.8, tooltip_size = 0.8, max_history = 50}

-- Garante que a tabela está inicializada
ChatMarkersConfig = ChatMarkersConfig or {
    tooltip_delay = 0.8,
    tooltip_size = 0.8,
    max_history = 50,
}

-- Funções de callback (podes personalizar)
local function OnTooltipDelayChanged(_, value)
    ChatMarkersConfig.tooltip_delay = value
    -- Exemplo: atualizar lógica que usa o delay
    print("Novo delay do tooltip:", value)
end

local function OnTooltipSizeChanged(_, value)
    ChatMarkersConfig.tooltip_size = value
    -- Exemplo: redimensionar tooltip ou frame
    if ChatMarkersTooltip then
        ChatMarkersTooltip:SetScale(value)
    end
    print("Nova escala do tooltip:", value)
end

local function OnMaxHistoryChanged(_, value)
    ChatMarkersConfig.max_history = value
    -- Exemplo: cortar o histórico se já estiver acima do novo limite
    if ChatMarkersHistory then
        while #ChatMarkersHistory > value do
            table.remove(ChatMarkersHistory)
        end
    end
    print("Novo tamanho máximo do histórico:", value)
end

-- Criação da categoria
local category = Settings.RegisterVerticalLayoutCategory("ChatMarkers2")

-- TOOLTIP_DELAY
do
    local setting = Settings.RegisterAddOnSetting(category, "Atraso do Tooltip", ChatMarkersConfig, "tooltip_delay", Settings.VarType.Number, 0.8)
    Settings.SetOnValueChangedCallback(setting, OnTooltipDelayChanged)
    local tooltip = "Tempo de atraso para mostrar o tooltip (em segundos)."
    Settings.CreateSlider(category, setting, tooltip, 0.0, 2.0, 0.1)
end

-- TOOLTIP_SIZE
do
    local setting = Settings.RegisterAddOnSetting(category, "Tamanho do Tooltip", ChatMarkersConfig, "tooltip_size", Settings.VarType.Number, 0.8)
    Settings.SetOnValueChangedCallback(setting, OnTooltipSizeChanged)
    local tooltip = "Escala do tooltip (0.5 a 1.5)."
    Settings.CreateSlider(category, setting, tooltip, 0.5, 1.5, 0.1)
end

-- MAX_HISTORY
do
    local setting = Settings.RegisterAddOnSetting(category, "Tamanho do Histórico", ChatMarkersConfig, "max_history", Settings.VarType.Number, 50)
    Settings.SetOnValueChangedCallback(setting, OnMaxHistoryChanged)
    local tooltip = "Número máximo de entradas no histórico."
    Settings.CreateSlider(category, setting, tooltip, 10, 100, 1)
end

-- Registar no painel
Settings.RegisterAddOnCategory(category)
