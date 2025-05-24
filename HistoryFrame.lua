-- Tabela global de histórico
ChatMarkersHistory = ChatMarkersHistory or {}

ChatMarkersConfig = ChatMarkersConfig or {
    tooltip_delay = 0.8,
    tooltip_size = 0.8,
    max_history = 50,
    enable_tooltips = true,
}

local _, ChatMarkers2 = ...

local historyFrame, scrollArea, scrollContent

function ChatMarkers2.CreateHistoryFrame()
    if historyFrame then return historyFrame end

    -- Frame histórico
    historyFrame = CreateFrame("Frame", "ChatMarkersHistoryFrame", UIParent, "BackdropTemplate")
    historyFrame:SetSize(315, 140)
    historyFrame:SetFrameLevel(10)
    historyFrame:SetMovable(true)
    historyFrame:EnableMouse(true)
    historyFrame:RegisterForDrag("LeftButton")
    historyFrame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    historyFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)
    historyFrame:SetPoint("CENTER")
    historyFrame:SetFrameStrata("DIALOG")
    historyFrame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark", tile = true })

    -- Cabeçalho
    local header = CreateFrame("Frame", nil, historyFrame)
    header:SetHeight(18)
    header:SetPoint("TOPLEFT", historyFrame, "TOPLEFT", 0, 0)
    header:SetPoint("TOPRIGHT", historyFrame, "TOPRIGHT", 0, 0)
    local headerBg = header:CreateTexture(nil, "BACKGROUND")
    headerBg:SetAllPoints()
    headerBg:SetColorTexture(0.15, 0.15, 0.15, 0.7)
    local title = header:CreateFontString(nil, "OVERLAY")
    title:SetPoint("CENTER", header, "CENTER", 0, -1)
    title:SetFont("Fonts\\ARIALN.TTF", 14, "OUTLINE")
    title:SetTextColor(1, 0.8, 0)
    title:SetText("HISTORY")

    -- Botão fechar
    local closeBtn = CreateFrame("Button", nil, historyFrame, "UIPanelCloseButton")
    closeBtn:SetSize(16, 16)
    closeBtn:SetPoint("TOPRIGHT", -3, -3)
    closeBtn:SetScript("OnClick", function()
        historyFrame:Hide()
    end)

    -- Área de scroll
    scrollArea = CreateFrame("ScrollFrame", nil, historyFrame, "UIPanelScrollFrameTemplate")
    scrollArea:SetSize(285, 113)
    scrollArea:SetPoint("TOPLEFT", 5, -23)
    scrollContent = CreateFrame("Frame", nil, scrollArea)
    scrollContent:SetSize(285, 113)
    scrollArea:SetScrollChild(scrollContent)

    historyFrame:Hide()
    return historyFrame
end

function ChatMarkers2.GetHistoryFrame()
    return historyFrame or ChatMarkers2.CreateHistoryFrame()
end

function ChatMarkers2.FillHistoryFrame()
    ChatMarkers2.CreateHistoryFrame()
    historyFrame:Show()

    -- Limpar conteúdo antigo
    for _, child in ipairs({scrollContent:GetChildren()}) do
        child:Hide()
    end

    -- Preencher com mensagens do histórico
    local max = ChatMarkersConfig.max_history or 50
    for i = 1, math.min(#ChatMarkersHistory, max) do
        local msg = ChatMarkersHistory[i]

        local row = CreateFrame("Button", nil, scrollContent, "BackdropTemplate")
        row:SetSize(285, 16)
        row:SetPoint("TOPLEFT", 0, -((i - 1) * 19))
        row:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
        row:SetBackdropColor(0.2, 0.2, 0.2, 0.4)

        local text = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("LEFT", 2, 0)
        text:SetFont("Fonts\\ARIALN.TTF", 12, "")
        text:SetWidth(260)
        text:SetJustifyH("LEFT")
        text:SetText(ReplaceMarkersWithIcons(msg))

        -- Botão Apagar
        local deleteBtn = CreateFrame("Button", nil, row)
        deleteBtn:SetSize(12, 12)
        deleteBtn:SetPoint("RIGHT", -15, 0)
        deleteBtn:SetNormalTexture("Interface\\AddOns\\ChatMarkers2\\media\\trash_gold.tga")
        deleteBtn:SetHighlightTexture("Interface\\Buttons\\WHITE8x8")
        local highlight = deleteBtn:GetHighlightTexture()
        highlight:SetPoint("TOPLEFT", 2, -2)
        highlight:SetPoint("BOTTOMRIGHT", -2, 2)
        highlight:SetVertexColor(1, 0, 0, 0.4)
        --if ChatMarkersConfig.enable_tooltips then
            SetupDelayedTooltip(deleteBtn, "Apagar")
        --end
        deleteBtn:SetScript("OnClick", function()
            table.remove(ChatMarkersHistory, i)
            ChatMarkers2.FillHistoryFrame()
        end)

        -- Botão Reenviar
        local resendBtn = CreateFrame("Button", nil, row)
        resendBtn:SetSize(12, 12)
        resendBtn:SetPoint("RIGHT", 0, 0)
        resendBtn:SetNormalTexture("Interface\\AddOns\\ChatMarkers2\\media\\send_gold.tga")
        resendBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
        --if ChatMarkersConfig.enable_tooltips then
            SetupDelayedTooltip(resendBtn, "Reenviar")
        --end
        resendBtn:SetScript("OnClick", function()
            if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
                SendChatMessage(msg, "INSTANCE_CHAT")
            elseif IsInRaid() then
                SendChatMessage(msg, "RAID")
            elseif IsInGroup() then
                SendChatMessage(msg, "PARTY")
            else
                print("Não estás num grupo, raid ou instância.")
            end
        end)
    end
end

function ChatMarkers2.AddToHistory(msg)
    if not msg or msg == "" then return end
    table.insert(ChatMarkersHistory, 1, msg)
    local max = ChatMarkersConfig.max_history or 50
    while #ChatMarkersHistory > max do
        table.remove(ChatMarkersHistory)
    end
end