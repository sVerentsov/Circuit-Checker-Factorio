require("log")
require("consts")
local function get_error_string(err)
    LOG(serpent.line(err))
    local prefix = ""
    if LEVEL_COLORS[err.level] ~= nil then
        prefix = prefix .. "[color=" .. LEVEL_COLORS[err.level][1] .. "," .. LEVEL_COLORS[err.level][2] .. "," ..
            LEVEL_COLORS[err.level][3] .. "]" .. err.level .. "[/color]: "
    else
        prefix = prefix .. err.level .. ": "
    end
    prefix = prefix .. "[img=entity/" .. err.entity.prototype.name .. "] " .. err.index .. ": "
    local localised_string = { err.msg, prefix }
    if err.params ~= nil then
        for _, param in pairs(err.params) do
            table.insert(localised_string, param)
        end
    end
    return localised_string
end

local function create_header(frame)
    local header = frame.add({
        type = "flow",
        name = "circuit_checker_report_header"
    })
    header.add({
        type = "label",
        caption = { "gui.title" },
        style = "frame_title"
    })
    header.add({
        type = "empty-widget",
        style = "circuit_checker_horizontal_pusher"
    })
    header.add({
        type = "sprite-button",
        name = "circuit_checker_report_close",
        style = "frame_action_button",
        sprite = "utility/close_white",
        hovered_sprite = "utility/close_black",
        clicked_sprite = "utility/close_black",
    })
end

local function create_error_list(frame, errors)
    local str_array = {}
    for _, err in pairs(errors) do
        table.insert(str_array, get_error_string(err))
    end
    local list_box = frame.add({
        type = "list-box",
        name = "circuit_checker_error_list",
        items = str_array,
        style = "circuit_checker_error_list"
    })
end

function SHOW_GUI(errors, player)
    local parent = player.gui.left
    parent.clear()
    local main_frame = parent.add({
        type = "frame",
        direction = "vertical",
        name = "circuit_checker_report"
    })
    create_header(main_frame)
    local content_frame = main_frame.add({
        type = "frame",
        name = "circuit_checker_content_frame",
        direction = "vertical",
        style = "inside_shallow_frame_with_padding"
    })
    create_error_list(content_frame, errors)

    SET_GUI(player.index, main_frame)
end

local function on_gui_click(event)
    if event.element.name == "circuit_checker_report_close" then
        CLOSE_GUI(event.player_index)
    end
end

local function on_selection_state_changed(event)
    if event.element.name == "circuit_checker_error_list" then
        local selected_error = global.players[event.player_index].errors[event.element.selected_index]
        game.players[event.player_index].zoom_to_world(selected_error.entity.position, 3, selected_error.entity)
    end
end

script.on_event(defines.events.on_gui_click, on_gui_click)
script.on_event(defines.events.on_gui_selection_state_changed, on_selection_state_changed)
