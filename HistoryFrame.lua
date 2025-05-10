-- tabela global de histórico (herdada de ChatMarkers.lua)
ChatMarkersHistory = ChatMarkersHistory or {}

-- cria a frame e o scroll, idempotentemente
local historyFrame, scrollArea, scrollContent

function CreateHistoryFrame()
    if historyFrame then return historyFrame end

    historyFrame = CreateFrame("Frame", "ChatMarkersHistoryFrame", UIParent, "BackdropTemplate")
    historyFrame:SetSize(315, 140)
    historyFrame:SetFrameLevel(10)
    historyFrame:SetMovable(true)
    historyFrame:EnableMouse(true)
    historyFrame:RegisterForDrag("LeftButton")
    historyFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)  -- Garantir que StartMoving é chamado no próprio historyFrame
    historyFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)  -- Garantir que StopMovingOrSizing é chamado no próprio historyFrame
    historyFrame:SetPoint("CENTER")
    historyFrame:SetFrameStrata("DIALOG")
    historyFrame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark", tile = true })

    -- cabeçalho
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

    -- close
    local closeBtn = CreateFrame("Button", nil, historyFrame, "UIPanelCloseButton")
    closeBtn:SetSize(16,16)
    closeBtn:SetPoint("TOPRIGHT", -3, -3)
    closeBtn:SetScript("OnClick", function() historyFrame:Hide() end)

    -- scroll
    scrollArea = CreateFrame("ScrollFrame", nil, historyFrame, "UIPanelScrollFrameTemplate")
    scrollArea:SetSize(285,113)
    scrollArea:SetPoint("TOPLEFT",5,-23)
    scrollContent = CreateFrame("Frame", nil, scrollArea)
    scrollContent:SetSize(285,113)
    scrollArea:SetScrollChild(scrollContent)
--[[
    -- botão Limpar Tudo
    local clearBtn = CreateFrame("Button", nil, historyFrame)
    clearBtn:SetSize(90, 17)
    clearBtn:SetPoint("BOTTOM", historyFrame, "BOTTOM", 0, 4)

    -- Adicionando um backdrop manual (frame de fundo)
    local backdrop = clearBtn:CreateTexture(nil, "BACKGROUND")
    backdrop:SetAllPoints()
    backdrop:SetColorTexture(0.85, 0.65, 0.1)  -- Cor dourada clara (RGB)

    -- Definindo o texto do botão
    clearBtn:SetText("Apagar tudo")

    -- Função de clique
    clearBtn:SetScript("OnClick", function()
        wipe(ChatMarkersHistory)
        ShowHistoryWindow()
    end)

 ]]

--[[
    local clearBtn = CreateFrame("Button", nil, historyFrame, "UIPanelButtonTemplate")
    clearBtn:SetSize(90, 17)
    clearBtn:SetPoint("BOTTOM", historyFrame, "BOTTOM", 0, 4)
    clearBtn:SetBackdropColor(0.1, 0.5, 0.1)
    clearBtn:SetText("Apagar tudo")
    clearBtn:SetScript("OnClick", function()
        wipe(ChatMarkersHistory)
        ShowHistoryWindow()
    end)
]]
    historyFrame:Hide()

    return historyFrame
end

function GetHistoryFrame()
    return historyFrame or CreateHistoryFrame()
end

-- função que exibe/atualiza o histórico
function ShowHistoryWindow()
    CreateHistoryFrame()       -- garante que scrollContent existe
    historyFrame:Show()

    -- limpa todo o conteúdo antigo
    for _, child in ipairs({scrollContent:GetChildren()}) do child:Hide() end

    -- popula com cada mensagem do histórico
    for i, msg in ipairs(ChatMarkersHistory) do
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
        text:SetText( ReplaceMarkersWithIcons(msg) )

        -- botão Apagar
        local deleteBtn = CreateFrame("Button", nil, row)
        deleteBtn:SetSize(12, 12)
        deleteBtn:SetPoint("RIGHT", -15, 0)
        deleteBtn:SetNormalTexture("Interface\\AddOns\\ChatMarkers2\\media\\trash_gold.tga")
        deleteBtn:SetHighlightTexture("Interface\\Buttons\\WHITE8x8")
        local highlight = deleteBtn:GetHighlightTexture()
        highlight:SetPoint("TOPLEFT", 2, -2)
        highlight:SetPoint("BOTTOMRIGHT", -2, 2)
        highlight:SetVertexColor(1, 0, 0, 0.4)  -- vermelho translúcido
        SetupDelayedTooltip(deleteBtn, "Apagar")
        deleteBtn:SetScript("OnClick", function()
            table.remove(ChatMarkersHistory, i)
            ShowHistoryWindow()
        end)

        -- botão Reenviar
        local resendBtn = CreateFrame("Button", nil, row)
        resendBtn:SetSize(12, 12)
        resendBtn:SetPoint("RIGHT", 0, 0)
        resendBtn:SetNormalTexture("Interface\\AddOns\\ChatMarkers2\\media\\send_gold.tga")
        resendBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
        SetupDelayedTooltip(resendBtn, "Reenviar")
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

