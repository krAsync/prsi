local card = {}
card.__index = card
function card:new(suit, value, sprite)
    local obj = setmetatable({}, card)
    obj.suit = suit
    obj.value = value
    obj.sprite = sprite
    obj.playable = false
    return obj
end

return card