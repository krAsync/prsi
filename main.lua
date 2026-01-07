local Deck = require("deck")
local hand = require("hand")

local current
local background
local cardback
local played = {}

local is_eso = false
local is_turn = true

-- =========================
-- LOVE.LOAD
-- =========================
function love.load()
    love.window.setFullscreen(true)

    background = love.graphics.newImage("assets/bg.png")
    cardback = love.graphics.newImage("assets/cardback.png")

    deck = Deck:new(played)
    player_hand = hand:new(deck)
    oponent_hand = hand:new(deck)

    current = deck:deal()

    update_playable(player_hand)
end

-- =========================
-- PLAYABLE LOGIC (JEDINÉ MÍSTO)
-- =========================
function update_playable(pl)
    for _, card in ipairs(pl.cards) do
        if is_eso then
            card.playable = (card.value == 'e')
        else
            card.playable =
                card.suit == current.suit or
                card.value == current.value
        end
    end
end

-- =========================
-- LOVE.UPDATE (OPONENT)
-- =========================
function love.update(dt)
    if not is_turn then
        update_playable(oponent_hand)

        for i, card in ipairs(oponent_hand.cards) do
            if card.playable then
                current = card

                if card.value == 'e' then
                    is_eso = true
                else
                    is_eso = false
                end

                oponent_hand:play(i)
                table.insert(played, card)

                is_turn = true
                update_playable(player_hand)
                return
            end
        end

        -- nemá hratelnou → dobírá
        oponent_hand:draw()
        is_turn = true
        update_playable(player_hand)
    end
end

-- =========================
-- DRAW
-- =========================
local CARD_SCALE = 0.28
local CARD_WIDTH = 140

function love.draw()
    local mid_x = love.graphics.getWidth() / 2
    local mid_y = love.graphics.getHeight() / 2

    love.graphics.draw(
        background, 0, 0, 0,
        love.graphics.getWidth() / background:getWidth(),
        love.graphics.getHeight() / background:getHeight()
    )

    local cardSpacing = CARD_WIDTH + 10
    local CARD_HEIGHT = CARD_WIDTH * 1.7

    -- OPONENT
    local totalOponentWidth =
        (#oponent_hand.cards * cardSpacing) - (cardSpacing - CARD_WIDTH)
    local oponentX =
        (love.graphics.getWidth() - totalOponentWidth) / 2

    local cardbackScale =
        (current.sprite:getWidth() * CARD_SCALE) / cardback:getWidth()

    local offset = 0
    for _ in ipairs(oponent_hand.cards) do
        love.graphics.draw(cardback, oponentX + offset, 100, 0,
            cardbackScale, cardbackScale)
        offset = offset + cardSpacing
    end

    -- PLAYER
    local totalWidth =
        (#player_hand.cards * cardSpacing) - (cardSpacing - CARD_WIDTH)
    local startX =
        (love.graphics.getWidth() - totalWidth) / 2
    local startY = love.graphics.getHeight() - 300

    local mouseX, mouseY = love.mouse.getPosition()
    offset = 0

    for _, card in ipairs(player_hand.cards) do
        love.graphics.draw(card.sprite,
            startX + offset, startY, 0,
            CARD_SCALE, CARD_SCALE)

        local hover =
            mouseX >= startX + offset and
            mouseX <= startX + offset + CARD_WIDTH and
            mouseY >= startY and
            mouseY <= startY + CARD_HEIGHT

        if hover then
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle(
                "line",
                startX + offset, startY,
                CARD_WIDTH, CARD_HEIGHT
            )
        end

        if card.playable then
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle(
                "line",
                startX + offset, startY,
                CARD_WIDTH, CARD_HEIGHT
            )
        end

        love.graphics.setColor(1, 1, 1)
        offset = offset + cardSpacing
    end

    -- CURRENT CARD + DECK
    love.graphics.draw(current.sprite,
        mid_x - (CARD_WIDTH / 2 + 20),
        mid_y - CARD_WIDTH * 0.85,
        0, CARD_SCALE, CARD_SCALE)

    love.graphics.draw(cardback,
        mid_x + (CARD_WIDTH / 2 + 20),
        mid_y - CARD_WIDTH * 0.85,
        0, cardbackScale, cardbackScale)
end

-- =========================
-- MOUSE INPUT
-- =========================

function love.mousepressed(x, y, button, istouch, presses)
    if button ~= 1 then return end

    local mouseX, mouseY = love.mouse.getPosition()

    -- =========================
    -- HRANÍ KARET
    -- =========================
    if is_turn then
        update_playable(player_hand)

        local cardSpacing = CARD_WIDTH + 10
        local totalWidth =
            (#player_hand.cards * cardSpacing) - (cardSpacing - CARD_WIDTH)
        local startX =
            (love.graphics.getWidth() - totalWidth) / 2
        local startY = love.graphics.getHeight() - 300
        local CARD_HEIGHT = CARD_WIDTH * 1.7

        local offset = 0
        for i, card in ipairs(player_hand.cards) do
            local isHovering =
                mouseX >= startX + offset and
                mouseX <= startX + offset + CARD_WIDTH and
                mouseY >= startY and
                mouseY <= startY + CARD_HEIGHT

            if isHovering and card.playable then
                current = card

                if card.value == 'e' then
                    is_eso = true
                else
                    is_eso = false
                end

                player_hand:play(i)
                table.insert(played, card)

                is_turn = false
                return
            end

            offset = offset + cardSpacing
        end
    end

    -- =========================
    -- PŮVODNÍ DECK HANDLING (BEZE ZMĚN)
    -- =========================
    local mid_x = love.graphics.getWidth() / 2
    local mid_y = love.graphics.getHeight() / 2

    local deckX = mid_x + (CARD_WIDTH/2 + 20)
    local deckY = mid_y - CARD_WIDTH * 0.85

    local deckWidth =
        cardback:getWidth() *
        ((current.sprite:getWidth() * CARD_SCALE) / cardback:getWidth())

    local deckHeight =
        cardback:getHeight() *
        ((current.sprite:getWidth() * CARD_SCALE) / cardback:getWidth())

    local isDeckHovering =
        mouseX >= deckX and mouseX <= deckX + deckWidth and
        mouseY >= deckY and mouseY <= deckY + deckHeight

    if isDeckHovering then
        -- TODO: Add deck click logic here
        player_hand:draw()
        is_turn = false
    end
end


