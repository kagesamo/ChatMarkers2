local _, ChatMarkers2 = ...

-- FUNÇÃO TOOLTIP --
function SetupDelayedTooltip(button, text)

    --if ChatMarkersConfig.enable_tooltips then

        local showTooltipTimer  -- Guarda o temporizador para poder cancelá-lo depois

        -- Quando o rato entra no botão
        button:HookScript("OnEnter", function(self)
            -- Inicia um temporizador para mostrar a tooltip após um atraso
            showTooltipTimer = C_Timer.After(ChatMarkersConfig.tooltip_delay or 0.8, function()
                -- Garante que o rato ainda está por cima do botão
                if not self:IsMouseOver() then return end

                -- Mostra a tooltip
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(text, 1, 1, 1)

                local scale = ChatMarkersConfig.tooltip_size or 0.8
                GameTooltip:SetScale(scale)

                GameTooltip:Show()
            end)
        end)

        -- Quando o rato sai do botão
        button:HookScript("OnLeave", function()
            -- Cancela o temporizador se ainda não executou
            if showTooltipTimer then
                showTooltipTimer:Cancel()
                showTooltipTimer = nil
            end

            -- Esconde a tooltip
            GameTooltip:Hide()
        end)
    --end
end


-- FUNÇÃO REPLACE MARKER TEXT POR ICON NO HISTÓRICO --
function ReplaceMarkersWithIcons(text)
    if type(text) ~= "string" then return text end

    -- Ícones de raid por nome
    local icons = {
        star = 1, circle = 2, diamond = 3, triangle = 4,
        moon = 5, square = 6, cross = 7, skull = 8
    }

    -- Substitui todos os marcadores encontrados
    return text:gsub("{(.-)}", function(tag)
        local index = icons[tag:lower()]
        if index then
            return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. index .. ":0|t"
        end
        return "{" .. tag .. "}" -- não encontrado: mantém como está
    end)
end


-- === Botão flutuante ===
function ChatMarkers2.CreateFloatingButton()
    local floatingBtn = CreateFrame("Button", "ChatMarkersFloatingButton", UIParent, "BackdropTemplate")
    floatingBtn:SetSize(24, 24)
    floatingBtn:SetPoint("CENTER", UIParent, "CENTER", 300, 0)
    floatingBtn:SetMovable(true)
    floatingBtn:EnableMouse(true)
    floatingBtn:RegisterForDrag("LeftButton")
    floatingBtn:SetScript("OnDragStart", floatingBtn.StartMoving)
    floatingBtn:SetScript("OnDragStop", floatingBtn.StopMovingOrSizing)

    local icon = floatingBtn:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_3")
    icon:SetAllPoints(floatingBtn)

    floatingBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    floatingBtn:SetScript("OnClick", function(self, button)
        if button == "RightButton" then
            -- Usando função global ou do namespace para abrir/fechar o histórico
            if ChatMarkers2.GetHistoryFrame and ChatMarkers2.ShowHistoryWindow then
                local hframe = ChatMarkers2.GetHistoryFrame()
                if hframe:IsShown() then
                    hframe:Hide()
                else
                    ChatMarkers2.ShowHistoryWindow()
                end
            end
        else
            -- Alternar a janela principal
            if ChatMarkers2.MainFrame then
                if ChatMarkers2.MainFrame:IsShown() then
                    ChatMarkers2.MainFrame:Hide()
                else
                    ChatMarkers2.MainFrame:Show()
                end
            end
--[[
            if ChatMarkers2.InputFrame then
                if ChatMarkers2.InputFrame:IsShown() then
                    ChatMarkers2.InputFrame:Hide()
                else
                    ChatMarkers2.InputFrame:Show()
                end
            end
             ]]
        end
    end)

    floatingBtn:Show()
    ChatMarkers2.FloatingBtn = floatingBtn
    return floatingBtn
end
