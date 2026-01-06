local Deck = require("deck")

function love.load()
    deck = Deck:new()
    print(deck:deal().suit)
end