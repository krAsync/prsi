local Deck = require("deck")
local hand = require("hand")
local current
local background
local cardback


function love.load()
    love.window.setFullscreen(true)
    background = love.graphics.newImage("assets/bg.png")
    cardback = love.graphics.newImage("assets/cardback.png")
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

-- Card display constants
local CARD_SCALE = 0.28  -- Scale for card sprites (original is 500px)
local CARD_WIDTH = 140  -- Scaled width (500 * 0.28)

function love.draw()
    mid_x = (love.graphics.getWidth()/2)
    mid_y = (love.graphics.getHeight()/2)
    -- Draw background
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / background:getWidth(), love.graphics.getHeight() / background:getHeight())

    check_playable(player_hand)

    local cardSpacing = CARD_WIDTH + 10
    local totalWidth = (#player_hand.cards * cardSpacing) - (cardSpacing - CARD_WIDTH)
    local startX = (love.graphics.getWidth() - totalWidth) / 2
    local startY = love.graphics.getHeight() - 300  -- 140px from bottom

    local cardOffset = 0
    for _,card in ipairs(player_hand.cards) do
        love.graphics.draw(card.sprite, startX + cardOffset, startY, 0, CARD_SCALE, CARD_SCALE)

        -- Draw green outline if card is active
        if card.is_active then
            love.graphics.setColor(0, 1, 0, 1)  -- Green color
            love.graphics.setLineWidth(3)
            love.graphics.rectangle("line", startX + cardOffset, startY, CARD_WIDTH, CARD_WIDTH * 1.7)
            love.graphics.setColor(1, 1, 1, 1)  -- Reset to white
        end

        cardOffset = cardOffset + cardSpacing
    end

    love.graphics.draw(current.sprite, mid_x - (CARD_WIDTH/2 + 20), mid_y - CARD_WIDTH * 0.85, 0, CARD_SCALE, CARD_SCALE)
    love.graphics.draw(cardback, mid_x + (CARD_WIDTH/2 + 20), mid_y - CARD_WIDTH * 0.85, 0, CARD_SCALE, CARD_SCALE)
end