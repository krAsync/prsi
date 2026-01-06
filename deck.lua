-- deck.lua
local Card = require("card")

local Deck = {}
Deck.__index = Deck

function Deck:new()
    local obj = setmetatable({}, Deck)
    obj.cards = {}
    obj:build()
    obj:shuffle()
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

function Deck:shuffle()
    -- Seed random number generator with current time
    math.randomseed(os.time())

    -- Fisher-Yates shuffle algorithm
    for i = #self.cards, 2, -1 do
        local j = math.random(1, i)
        self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
    end
end

function Deck:deal()
    return table.remove(self.cards, 1)
end

return Deck
