-- card.lua
local Card = {}
Card.__index = Card

function Card:new(suit, value, sprite)
    local obj = setmetatable({}, Card)
    obj.suit = suit
    obj.value = value
    obj.sprite = sprite
    return obj
end

return Card
