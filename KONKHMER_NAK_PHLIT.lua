-- KONKHMER NAK PHLIT | loader only
local CORE = "https://raw.githubusercontent.com/makarachan-dotcom/konkhmer-nak-phlit/main/core.lua"

local byGameId = {
    [10563114921] = CORE,
    [7709344486] = CORE,
}

local byPlaceId = {
    [107778070777162] = CORE,
    [109983668079237] = CORE,
}

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local gameId = game.GameId
while gameId == 0 and game.PlaceId == 0 do
    task.wait()
    gameId = game.GameId
end

local url = byGameId[gameId] or byPlaceId[game.PlaceId] or CORE

for _ = 1, 3 do
    local ok, source = pcall(game.HttpGet, game, url .. "?t=" .. tostring(os.clock()))
    if ok and type(source) == "string" and #source > 32 then
        local chunk = loadstring(source)
        if chunk then
            chunk()
            return
        end
    end
    task.wait(0.5)
end
