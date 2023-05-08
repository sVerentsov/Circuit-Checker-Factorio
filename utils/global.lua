local function get_or_create_player_data(player_index)
    if global.players == nil then
        global.players = {}
    end
    if global.players[player_index] == nil then
        global.players[player_index] = {}
    end
    return global.players[player_index]
end

function SET_ERRORS(player_index, errors)
    local player_data = get_or_create_player_data(player_index)
    player_data.errors = errors
end

function SET_GUI(player_index, gui)
    local player_data = get_or_create_player_data(player_index)
    player_data.gui = gui
end

function CLOSE_GUI(player_index)
    local player_data = get_or_create_player_data(player_index)
    if player_data.gui ~= nil then
        player_data.gui.destroy()
        player_data.gui = nil
    end
end

function CLOSE_ALL_GUI()
    if global.players == nil then
        return
    end
    for _, player_data in pairs(global.players) do
        if player_data.gui ~= nil then
            player_data.gui.destroy()
            player_data.gui = nil
        end
    end
end
