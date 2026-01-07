local Deck = require("deck")
local hand = require("hand")
local current
local background
local cardback
local played = {}
is_turn = true

function love.load()
    love.window.setFullscreen(true)
    background = love.graphics.newImage("assets/bg.png")
    cardback = love.graphics.newImage("assets/cardback.png")
    deck = Deck:new(played)
    player_hand = hand:new(deck)
    oponent_hand = hand:new(deck)
    current = deck:deal()
end
--- check if cards are playable if yes change its is_playable atribute to true
local function check_playable(player)
    for i, card in ipairs(player.cards) do
        if card.suit == current.suit or card.value == current.value then
            player.cards[i].playable = true
        else
            player.cards[i].playable = false
        end
    end
end

function love.update(dt)
    if not is_turn then
        check_playable(oponent_hand)
        for i,card in ipairs(oponent_hand.cards) do
            if not is_turn then
            if card.playable then
                oponent_hand:play(i)
                current = card
                table.insert(played, card)
                is_turn = true
                break
            end
        end
    end
        if not is_turn then
            oponent_hand:draw()
            is_turn = true
    end
end
end

local CARD_SCALE = 0.28 
local CARD_WIDTH = 140 

function love.draw()
    mid_x = (love.graphics.getWidth()/2)
    mid_y = (love.graphics.getHeight()/2)
    -- Draw background
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / background:getWidth(), love.graphics.getHeight() / background:getHeight())

    check_playable(player_hand)

    local cardSpacing = CARD_WIDTH + 10
    local totalOponentWidth = (#oponent_hand.cards * cardSpacing) - (cardSpacing - CARD_WIDTH)
    local OponentstartX = (love.graphics.getWidth() - totalOponentWidth) / 2
    local totalWidth = (#player_hand.cards * cardSpacing) - (cardSpacing - CARD_WIDTH)
    local startX = (love.graphics.getWidth() - totalWidth) / 2
    local startY = love.graphics.getHeight() - 300  -- 140px 

    local cardOffset = 0
    local mouseX, mouseY = love.mouse.getPosition()
    local CARD_HEIGHT = CARD_WIDTH * 1.7
    local cardbackScale = (current.sprite:getWidth() * CARD_SCALE) / cardback:getWidth()
        for _,card in ipairs(oponent_hand.cards) do
        love.graphics.draw(cardback, OponentstartX + cardOffset,  100,0, cardbackScale, cardbackScale)
        cardOffset = cardOffset + cardSpacing
    end
    cardOffset = 0
    for _,card in ipairs(player_hand.cards) do
        love.graphics.draw(card.sprite, startX + cardOffset, startY, 0, CARD_SCALE, CARD_SCALE)


        local isHovering = mouseX >= startX + cardOffset and mouseX <= startX + cardOffset + CARD_WIDTH and
                          mouseY >= startY and mouseY <= startY + CARD_HEIGHT

        -- Draw white outline if hovering
        if isHovering then
            love.graphics.setColor(1, 1, 1, 1)  
            love.graphics.setLineWidth(3)
            love.graphics.rectangle("line", startX + cardOffset, startY, CARD_WIDTH, CARD_HEIGHT)
            love.graphics.setColor(1, 1, 1, 1)  
        end


        if card.playable then
            love.graphics.setColor(0, 1, 0, 1)  
            love.graphics.setLineWidth(3)
            love.graphics.rectangle("line", startX + cardOffset, startY, CARD_WIDTH, CARD_HEIGHT)
            love.graphics.setColor(1, 1, 1, 1) 
        end

        cardOffset = cardOffset + cardSpacing
    end




    love.graphics.draw(current.sprite, mid_x - (CARD_WIDTH/2 + 20), mid_y - CARD_WIDTH * 0.85, 0, CARD_SCALE, CARD_SCALE)
    love.graphics.draw(cardback, mid_x + (CARD_WIDTH/2 + 20), mid_y - CARD_WIDTH * 0.85, 0, cardbackScale, cardbackScale)
end

function love.mousepressed(x, y, button, istouch, presses)
    check_playable(player_hand)
    if button == 1 then
        local cardSpacing = CARD_WIDTH + 10
        local totalWidth = (#player_hand.cards * cardSpacing) - (cardSpacing - CARD_WIDTH)
        local startX = (love.graphics.getWidth() - totalWidth) / 2
        local startY = love.graphics.getHeight() - 300  -- 140px

        local cardOffset = 0
        local mouseX, mouseY = love.mouse.getPosition()
        local CARD_HEIGHT = CARD_WIDTH * 1.7
        check_playable(player_hand)
        for i, card in ipairs(player_hand.cards) do
            print(card.playable)
            local isHovering = mouseX >= startX + cardOffset and mouseX <= startX + cardOffset + CARD_WIDTH and mouseY >= startY and mouseY <= startY + CARD_HEIGHT

            if isHovering and card.playable and is_turn then
                -- TODO: Add card play logic here
                current = card
                player_hand:play(i)
                table.insert(played, card)
                is_turn = false
                break
            end
            print(card.playable)

            cardOffset = cardOffset + cardSpacing
        end

        -- Check if hovering over deck
        local deckX = mid_x + (CARD_WIDTH/2 + 20)
        local deckY = mid_y - CARD_WIDTH * 0.85
        local deckWidth = cardback:getWidth() * ((current.sprite:getWidth() * CARD_SCALE) / cardback:getWidth())
        local deckHeight = cardback:getHeight() * ((current.sprite:getWidth() * CARD_SCALE) / cardback:getWidth())

        local isDeckHovering = mouseX >= deckX and mouseX <= deckX + deckWidth and
                               mouseY >= deckY and mouseY <= deckY + deckHeight

        if isDeckHovering then
            -- TODO: Add deck click logic here
            player_hand:draw()
            is_turn = false
        end
    end
end