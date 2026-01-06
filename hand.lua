local Card = require("card")
local Deck = require("deck")
local hand = {}
hand.__index = hand 

function hand:new(deck)
    local obj = setmetatable({}, hand)
    obj.cards = {}
    obj.deck = deck
    obj:build()
    return obj
end

function hand:build()
    for i = 1, 5 do
        table.insert(self.cards, self.deck:deal())
    end
end

function hand:draw()
    table.insert(self.cards, self.deck:deal())
end
function hand:play(card)
    -- card is index
    table.remove(self.cards, card)
end

return hand