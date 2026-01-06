local Deck = require("deck")
local hand = require("hand")
local current

function love.load()
    deck = Deck:new()
    player_hand = hand:new(deck)
    oponent_hand = hand:new(deck)
    current = deck:deal()
end
--- check if cards are playable if yes change its is_playable atribute to true
local function check_playable(player)
    for _, card in ipairs(player.cards) do
        if card.suit == current.suit or card.value == current.value then
            card.is_active = true
        end
    end
end

function love.draw()
    local cardGap = 0
    for _,card in ipairs(player_hand.cards) do
        love.graphics.draw(card.sprite, 20 + cardGap, 10, 0)
        cardGap = cardGap + 100
    end
end