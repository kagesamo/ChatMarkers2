local _, ChatMarkers2 = ...

--== Main Frame ==--

local mainFrame

function ChatMarkers2.CreateMainFrame()

    if mainFrame then return mainFrame end

    mainFrame = CreateFrame("Frame", "ChatMarkersMainFrame", UIParent, "BackdropTemplate")
    mainFrame:SetSize(600, 300)
    mainFrame:SetFrameLevel(10)
    mainFrame:SetMovable(true)
    mainFrame:EnableMouse(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    mainFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)
    mainFrame:SetPoint("CENTER")
    mainFrame:SetFrameStrata("DIALOG")
    mainFrame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark", tile = true })

    -- Cabeçalho
    local header = CreateFrame("Frame", nil, mainFrame)
    header:SetHeight(18)
    header:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 0, 0)
    header:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", 0, 0)
    local headerBg = header:CreateTexture(nil, "BACKGROUND")
    headerBg:SetAllPoints()
    headerBg:SetColorTexture(0.15, 0.15, 0.15, 0.7)
    local title = header:CreateFontString(nil, "OVERLAY")
    title:SetPoint("CENTER", header, "CENTER", 0, -1)
    title:SetFont("Fonts\\ARIALN.TTF", 14, "OUTLINE")
    title:SetTextColor(1, 0.8, 0)
    title:SetText("ChatMarkers2")

    -- Botão fechar
    local closeBtn = CreateFrame("Button", nil, mainFrame, "UIPanelCloseButton")
    closeBtn:SetSize(16, 16)
    closeBtn:SetPoint("TOPRIGHT", -3, -3)
    closeBtn:SetScript("OnClick", function()
        mainFrame:Hide()
    end)

    mainFrame:Hide()

    return mainFrame

end

-- Criação da main frame
ChatMarkers2.InputFrame = ChatMarkers2.CreateInputFrame()

-- Criação do botão flutuante
ChatMarkers2.FloatingBtn = ChatMarkers2.CreateFloatingButton()

-- Criação da input frame
ChatMarkers2.InputFrame = ChatMarkers2.CreateMainFrame()