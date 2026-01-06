-- deck.lua
local Card = require("card")

local Deck = {}
Deck.__index = Deck

function Deck:new()
    local obj = setmetatable({}, Deck)
    obj.cards = {}
    obj:build()
    return obj
end

function Deck:build()
    local files = love.filesystem.getDirectoryItems("assets/cards")

    for _, file in ipairs(files) do
        if file:match("%.png$") then
            local name = file:gsub("%.png$", "")
            local suit = name:sub(1,1)
            local value = name:sub(2)

            local sprite = love.graphics.newImage("assets/cards/" .. file)
            local card = Card:new(suit, value, sprite)
            
            table.insert(self.cards, card)
        end
       
    end
end

function Deck:deal()
    return table.remove(self.cards, 1)
end

return Deck
