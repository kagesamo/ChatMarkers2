local _, ChatMarkers2 = ...

local inputFrame

function ChatMarkers2.CreateInputFrame()

    local markers = {
        { icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1", tag = "{star} " },
        { icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_2", tag = "{circle} " },
        { icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_3", tag = "{diamond} " },
        { icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_4", tag = "{triangle} " },
        { icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_5", tag = "{moon} " },
        { icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_6", tag = "{square} " },
        { icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_7", tag = "{cross} " },
        { icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8", tag = "{skull} " },
    }

    local customButtons = {
        { label = "G", tag = "Grp " },
        { label = "1", tag = "1 " },
        { label = "3", tag = "3 " },
        { label = "5", tag = "5 " },
        { label = "&", tag = "& " },
        { label = "<", tag = "LEFT " },
        { label = "+", tag = "+ " },
        { label = "2", tag = "2 " },
        { label = "4", tag = "4 " },
        { label = "6", tag = "6 " },
        { label = "/", tag = "/ " },
        { label = ">", tag = "RIGHT " },
    }

    -- === inputFrame principal ===
    local inputFrame = CreateFrame("Frame", "ChatMarkersFrame", UIParent, "BackdropTemplate")
    inputFrame:SetSize(315, 80)
    inputFrame:SetFrameStrata("DIALOG")
    inputFrame:SetFrameLevel(10)
    inputFrame:SetMovable(true)
    inputFrame:EnableMouse(true)
    inputFrame:RegisterForDrag("LeftButton", "RightButton")
    inputFrame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    inputFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)
    inputFrame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark", tile = true })

    -- === Caixa de texto ===
    local editBox = CreateFrame("EditBox", nil, inputFrame, "BackdropTemplate")
    editBox:SetSize(290, 20)
    editBox:SetPoint("BOTTOM", inputFrame, "BOTTOM", -7, 7)
    editBox:SetAutoFocus(false)
    editBox:SetFont("Fonts\\ARIALN.TTF", 14, "")
    editBox:SetTextColor(1, 1, 0)
    editBox:SetTextInsets(6, 6, 0, 0)
    editBox:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 8,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    editBox:SetBackdropColor(1, 1, 1, 0.1)
    editBox:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.8)

    -- === Funções de botões ===
    local function CreateMarkerButton(parent, texturePath, tag, size, x, y)
        local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
        btn:SetSize(size, size)
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
        btn.icon = btn:CreateTexture(nil, "BACKGROUND")
        btn.icon:SetAllPoints()
        btn.icon:SetTexture(texturePath)
        local highlight = btn:CreateTexture(nil, "HIGHLIGHT")
        highlight:SetAllPoints()
        highlight:SetColorTexture(1, 1, 1, 0.35)
        btn:SetScript("OnClick", function()
            editBox:SetText(editBox:GetText() .. tag)
            editBox:SetFocus()
            editBox:ClearHighlightText()
        end)
    end

    local function CreateCustomButton(parent, label, tag, size, x, y)
        local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
        btn:SetSize(size, size)
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
        btn:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = false, edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        btn:SetBackdropColor(0.15, 0.15, 0.15, 0.8)
        btn:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.8)
        btn.text = btn:CreateFontString(nil, "OVERLAY")
        btn.text:SetFont("Fonts\\ARIALN.TTF", 15, "OUTLINE")
        btn.text:SetPoint("CENTER", btn, "CENTER", 0.75, -0.25)
        btn.text:SetText(label)
        btn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
        btn:SetScript("OnClick", function()
            editBox:SetText(editBox:GetText() .. tag)
            editBox:SetFocus()
            editBox:ClearHighlightText()
        end)
    end

    -- === Colocação dos botões ===
    local buttonSize, customBtnSize = 18, 18
    local spacing, customSpacing = 4, 4
    local offsetY = -8
    local customCols = 6
    local customStartX = 8
    local customStartY = offsetY

    for i, btnInfo in ipairs(customButtons) do
        local row = math.floor((i - 1) / customCols)
        local col = (i - 1) % customCols
        CreateCustomButton(inputFrame, btnInfo.label, btnInfo.tag, customBtnSize,
            customStartX + col * (customBtnSize + customSpacing),
            customStartY - row * (customBtnSize + customSpacing))
    end

    local markerStartX = customStartX + (customCols * (customBtnSize + customSpacing))
    local buttonsPerRow = 4

    for i, marker in ipairs(markers) do
        local row = math.floor((i - 1) / buttonsPerRow)
        local col = (i - 1) % buttonsPerRow
        CreateMarkerButton(inputFrame, marker.icon, marker.tag, buttonSize,
            markerStartX + col * (buttonSize + spacing),
            offsetY - row * (buttonSize + spacing))
    end

    -- === Botões de ação: ENVIAR / LIMPAR ===

--    local actionFrame = CreateFrame("Frame", nil, inputFrame)
--    actionFrame:SetSize(220, 20)
--    actionFrame:SetPoint("BOTTOM", inputFrame, "BOTTOM", 0, 10)

    local function CreateActionButton(parent, label, callback)
        local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
        btn:SetSize(50, 16)
        btn:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = false, edgeSize = 10,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        btn:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.8)
        btn.text = btn:CreateFontString(nil, "OVERLAY")
        btn.text:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
        btn.text:SetPoint("CENTER", btn, "CENTER", 0, -0.5)
        btn.text:SetText(label)
        btn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
        btn:SetScript("OnClick", callback)
        return btn
    end

    -- Botão enviar --
    local sendBtn = CreateActionButton(inputFrame, "SEND", function()
        local msg = editBox:GetText()
        local hframe = ChatMarkers2.GetHistoryFrame()
        if msg ~= "" then
            ChatMarkers2.AddToHistory(msg)
            if hframe:IsShown() then
                ChatMarkers2.FillHistoryFrame()
            else
                ChatMarkers2.FillHistoryFrame()
                hframe:Hide()
            end
        end

        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
            SendChatMessage(msg, "INSTANCE_CHAT")
        elseif IsInRaid() then
            SendChatMessage(msg, "RAID")
        elseif IsInGroup() then
            SendChatMessage(msg, "PARTY")
        else
            print("Não estás num grupo, raid ou instância. No entanto, foi guardado no histórico.")
        end
    end)
    --sendBtn:SetSize(40, 21)
    sendBtn:SetPoint("TOPRIGHT", inputFrame, "TOPRIGHT", -10, -3)
    sendBtn:SetBackdropColor(0.1, 0.5, 0.1)
    SetupDelayedTooltip(sendBtn, "Send to group chat")

    -- Botão guardar --
    local saveBtn = CreateActionButton(inputFrame, "SAVE", function()
        local msg = editBox:GetText()
        local hframe = ChatMarkers2.GetHistoryFrame()
        if msg ~= "" then
            ChatMarkers2.AddToHistory(msg)
            if hframe:IsShown() then
                ChatMarkers2.FillHistoryFrame()
            else
                ChatMarkers2.FillHistoryFrame()
                hframe:Hide()
            end
        end
    end)
    --saveBtn:SetSize(40, 21)
    saveBtn:SetPoint("TOP", sendBtn, "BOTTOM", 0, 0)
    saveBtn:SetBackdropColor(0.1, 0.1, 0.5)
    SetupDelayedTooltip(saveBtn, "Save to history")

    -- Botão limpar --
    local clearBtn = CreateActionButton(inputFrame, "CLEAR", function()
        editBox:SetText("")
        editBox:SetFocus()
    end)
    clearBtn:SetPoint("TOP", saveBtn, "BOTTOM", 0, 0)
    clearBtn:SetBackdropColor(0.4, 0.1, 0.1)
    SetupDelayedTooltip(clearBtn, "Clear text box")

    -- === Botão destaque ===
    local highlightBtn = CreateFrame("Button", nil, inputFrame, "BackdropTemplate")
    highlightBtn:SetSize(14, 14)
    highlightBtn:SetPoint("LEFT", editBox, "RIGHT", 0, 0)
    highlightBtn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false, edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    highlightBtn:SetBackdropColor(0.15, 0.15, 0.15, 0.8)
    highlightBtn:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.8)
    highlightBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    --if ChatMarkersConfig and ChatMarkersConfig.enable_tooltips then
        SetupDelayedTooltip(highlightBtn, "Select all text")
    --end
    highlightBtn:SetScript("OnClick", function()
        editBox:HighlightText()
        editBox:SetFocus()
    end)

    -- == Botão fechar ==
    local closeBtn = CreateFrame("Button", nil, inputFrame, "UIPanelCloseButton")
    closeBtn:SetSize(14, 14)
    closeBtn:SetPoint("TOPRIGHT", 4, 4)
    closeBtn:SetScript("OnClick", function() inputFrame:Hide() end)

    -- Exporta referência da editBox só se precisares noutros módulos
    ChatMarkers2.InputEditBox = editBox

    inputFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    inputFrame:Hide()

    return inputFrame
end

function ChatMarkers2.GetInputFrame()
    return inputFrame or ChatMarkers2.CreateInputFrame()
end
