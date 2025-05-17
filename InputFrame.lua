-- === Dados dos ícones ===
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
    { label = "1", tag = "1 " },
    { label = "3", tag = "3 " },
    { label = "5", tag = "5 " },
    { label = "&", tag = "& " },
    { label = "<", tag = "LEFT " },
    { label = "2", tag = "2 " },
    { label = "4", tag = "4 " },
    { label = "6", tag = "6 " },
    { label = "/", tag = "/ " },
    { label = ">", tag = "RIGHT " },
}


-- === Frame principal ===
local frame = CreateFrame("Frame", "ChatMarkersFrame", UIParent, "BackdropTemplate")
frame:SetSize(290, 80)
frame:SetFrameStrata("HIGH")
frame:SetFrameLevel(10)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark", tile = true })


-- === Caixa de texto ===
local editBox = CreateFrame("EditBox", nil, frame, "BackdropTemplate")
editBox:SetSize(265, 20)
editBox:SetPoint("BOTTOM", frame, "BOTTOM", -7, 7)
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
    btn.text:SetPoint("CENTER", btn, "CENTER", 0.5, 0)
    btn.text:SetText(label)
    btn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    btn:SetScript("OnClick", function()
        editBox:SetText(editBox:GetText() .. tag)
        editBox:SetFocus()
        editBox:ClearHighlightText()
    end)
end


-- === Colocação dos botões ===
local buttonSize = 18
local customBtnSize = 18
local spacing = 4
local customSpacing = 4
local offsetY = -8
local customCols = 5
local customStartX = 8
local customStartY = offsetY

for i, btnInfo in ipairs(customButtons) do
    local row = math.floor((i - 1) / customCols)
    local col = (i - 1) % customCols
    CreateCustomButton(frame, btnInfo.label, btnInfo.tag, customBtnSize,
        customStartX + col * (customBtnSize + customSpacing),
        customStartY - row * (customBtnSize + customSpacing))
end

local markerStartX = customStartX + (customCols * (customBtnSize + customSpacing))
local buttonsPerRow = 4

for i, marker in ipairs(markers) do
    local row = math.floor((i - 1) / buttonsPerRow)
    local col = (i - 1) % buttonsPerRow
    CreateMarkerButton(frame, marker.icon, marker.tag, buttonSize,
        markerStartX + col * (buttonSize + spacing),
        offsetY - row * (buttonSize + spacing))
end


-- === Botões de ação: ENVIAR / LIMPAR ===
local actionFrame = CreateFrame("Frame", nil, frame)
actionFrame:SetSize(220, 20)
actionFrame:SetPoint("BOTTOM", frame, "BOTTOM", 0, 10)

local function CreateActionButton(parent, label, callback)
    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(75, 21)
    btn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false, edgeSize = 10,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    btn:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.8)
    btn.text = btn:CreateFontString(nil, "OVERLAY")
    btn.text:SetFont("Fonts\\FRIZQT__.TTF", 13, "")
    btn.text:SetPoint("CENTER", btn, "CENTER", 0, -0.5)
    btn.text:SetText(label)
    btn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    btn:SetScript("OnClick", callback)
    return btn
end

local sendBtn = CreateActionButton(actionFrame, "ENVIAR", function()
    local msg = editBox:GetText()
    local hf = GetHistoryFrame()
    if msg ~= "" then
        AddToHistory(msg)
        if hf:IsShown() then
            ShowHistoryWindow()
        else
            ShowHistoryWindow()
            hf:Hide()
        end
    end

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
sendBtn:SetPoint("TOPLEFT", frame, "TOPRIGHT", -82, -7)
sendBtn:SetBackdropColor(0.1, 0.5, 0.1)

local clearBtn = CreateActionButton(actionFrame, "LIMPAR", function()
    editBox:SetText("")
    editBox:SetFocus()
end)
clearBtn:SetPoint("TOP", sendBtn, "BOTTOM", 0, -2)
clearBtn:SetBackdropColor(0.4, 0.1, 0.1)


-- === Botão de destaque ===
local copyBtn = CreateFrame("Button", nil, frame, "BackdropTemplate")
copyBtn:SetSize(14, 14)
copyBtn:SetPoint("LEFT", editBox, "RIGHT", 0, 0)
copyBtn:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false, edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 },
})
copyBtn:SetBackdropColor(0.15, 0.15, 0.15, 0.8)
copyBtn:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.8)
copyBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
if ChatMarkersConfig.enable_tooltips then
    SetupDelayedTooltip(copyBtn, "Destacar")
end
copyBtn:SetScript("OnClick", function()
    editBox:HighlightText()
    editBox:SetFocus()
end)


frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
frame:Hide()