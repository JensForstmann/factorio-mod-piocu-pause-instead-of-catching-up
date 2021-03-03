local function ensure_ui()
    for _, player in pairs(game.players) do
        if game.tick_paused then
            if not player.gui.screen["piocu_frame"] or not player.gui.screen["piocu_frame"].valid then
                local frame = player.gui.screen.add{
                    type="frame",
                    name="piocu_frame",
                    caption={"message.window-title"}
                }
                frame.auto_center = true
                local button = frame.add{
                    type="button",
                    name="piocu_button",
                    caption={"message.button-text"}
                }
            end
        else
            if player.gui.screen["piocu_frame"] and player.gui.screen["piocu_frame"].valid then
                player.gui.screen["piocu_frame"].destroy()
            end
        end
    end
end

local function pause()
    game.tick_paused = true
    ensure_ui()
    -- game.print("Game is paused.")
end

local function unpause()
    game.tick_paused = false
    ensure_ui()
    -- game.print("Game is unpaused.")
end

local function player_left(player)
    local player_count = #game.connected_players

    if player_count == 0 then
        -- game.print("Game will paused.")
        pause()
    end
end

local function player_joined(player)
    -- game.print("piocu: Player " .. player.name .. " joined")
    ensure_ui(player)
end

-- event registrations
script.on_event(defines.events.on_player_joined_game, function (event)
    player_joined(game.players[event.player_index])
end)

script.on_event(defines.events.on_player_left_game, function (event)
    player_left(game.players[event.player_index])
end)

script.on_event(defines.events.on_gui_click, function(event)
    if event.element.name == "piocu_button" then
        unpause()
    end
end)

-- command registration
commands.add_command("unpause", "", function ()
    unpause()
end)

commands.add_command("pause", "", function ()
    pause()
end)

commands.add_command("ensure_ui", "", function ()
    ensure_ui()
end)