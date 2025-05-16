-- FUNÇÃO TOOLTIP --
function SetupDelayedTooltip(button, text)
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
