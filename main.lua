local Deck = require("deck")
local hand = require("hand")
local current

function love.load()
    love.window.setFullscreen(true)
    deck = Deck:new()
    player_hand = hand:new(deck)
    oponent_hand = hand:new(deck)
    current = deck:deal()
end
--- check if cards are playable if yes change its is_playable atribute to true
local function check_playable(player)
    for i, card in ipairs(player.cards) do
        if card.suit == current.suit or card.value == current.value then
            player.cards[i].is_active = true
        end
    end
end

function love.draw()
    check_playable(player_hand)

    local cardScale = 0.14  -- 70px wide (original is 500px)
    local cardWidth = 70
    local cardSpacing = 75
    local totalWidth = (#player_hand.cards * cardSpacing) - (cardSpacing - cardWidth)
    local startX = (love.graphics.getWidth() - totalWidth) / 2
    local startY = love.graphics.getHeight() - 140  -- 140px from bottom

    local cardOffset = 0
    for _,card in ipairs(player_hand.cards) do
        love.graphics.draw(card.sprite, startX + cardOffset, startY, 0, cardScale, cardScale)

        -- Draw green outline if card is active
        if card.is_active then
            love.graphics.setColor(0, 1, 0, 1)  -- Green color
            love.graphics.setLineWidth(3)
            love.graphics.rectangle("line", startX + cardOffset, startY, cardWidth, cardWidth * 1.7)
            love.graphics.setColor(1, 1, 1, 1)  -- Reset to white
        end

        cardOffset = cardOffset + cardSpacing
    end

    love.graphics.draw(current.sprite, love.graphics.getWidth()/2, love.graphics.getHeight()/2,0, cardScale, cardScale)
end