require("consts")


local inserter_mode = {
    [defines.control_behavior.inserter.circuit_mode_of_operation.enable_disable] = 'enable_disable_icon',
    [defines.control_behavior.inserter.circuit_mode_of_operation.set_filters] = 'set_filter_icon',
    [defines.control_behavior.inserter.circuit_mode_of_operation.read_hand_contents] = 'read_hand_icon',
    [defines.control_behavior.inserter.circuit_mode_of_operation.set_stack_size] = 'set_stack_size',
}

local inserter_read_mode = {
    [defines.control_behavior.inserter.hand_read_mode.hold] = 'hold_icon',
    [defines.control_behavior.inserter.hand_read_mode.pulse] = 'pulse_icon'
}

local function inserter_icons(control_behavior)
    local ans = {}
    local mode_icon = inserter_mode[control_behavior.circuit_mode_of_operation]
    if mode_icon ~= nil then
        table.insert(ans, mode_icon)
    end
    if control_behavior.circuit_read_hand_contents then
        table.insert(ans, inserter_read_mode[control_behavior.circuit_hand_read_mode])
    end
    if control_behavior.circuit_set_stack_size then
        table.insert(ans, 'set_stack_size')
    end
    return ans
end

local function lamp_icons(control_behavior)
    local ans = {}
    if control_behavior.use_colors then
        table.insert(ans, "use_colors")
    end
    return ans
end

local logistic_mode = {
    [defines.control_behavior.logistic_container.circuit_mode_of_operation.send_contents] = 'send_contents',
    [defines.control_behavior.logistic_container.circuit_mode_of_operation.set_requests] = 'set_requests',
}

local function logistic_container_icons(control_behavior)
    local ans = {}
    local mode_icon = logistic_mode[control_behavior.circuit_mode_of_operation]
    if mode_icon ~= nil then
        table.insert(ans, mode_icon)
    end
    return ans
end

local function roboport_icons(control_behavior)
    local ans = {}
    if control_behavior.read_logistics then
        table.insert(ans, "send_contents")
    end
    if control_behavior.read_robot_stats then
        table.insert(ans, "read_robot_stats")
    end
    return ans
end

local function train_stop_icons(control_behavior)
    local ans = {}
    if control_behavior.enable_disable then
        table.insert(ans, "enable_disable_icon")
    end
    if control_behavior.send_to_train then
        table.insert(ans, "send_to_train")
    end
    if control_behavior.set_trains_limit then
        table.insert(ans, "set_trains_limit")
    end
    if control_behavior.read_from_train then
        table.insert(ans, "send_contents")
    end
    if control_behavior.read_stopped_train then
        table.insert(ans, "read_stopped_train")
    end
    if control_behavior.read_trains_count then
        table.insert(ans, "read_trains_count")
    end
    return ans
end

local function decider_icons(control_behavior)
    local ans = {}
    if control_behavior.parameters.copy_count_from_input == false then
        table.insert(ans, "output_one")
    end
    return ans
end

local function constant_combinator_icons(control_behavior)
    local ans = {}
    if control_behavior.enabled == false then
        table.insert(ans, "disabled")
    end
    return ans
end

local belt_read_mode = {
    [defines.control_behavior.transport_belt.content_read_mode.pulse] = 'pulse_icon',
    [defines.control_behavior.transport_belt.content_read_mode.hold] = 'hold_icon'
}

local function belt_icons(control_behavior)
    local ans = {}
    if control_behavior.enable_disable then
        table.insert(ans, "enable_disable_icon")
    end
    if control_behavior.read_contents then
        table.insert(ans, belt_read_mode[control_behavior.read_contents_mode])
    end
    return ans
end

local function rail_signal_icons(control_behavior)
    local ans = {}
    if control_behavior.close_signal then
        table.insert(ans, "stop_icon")
    end
    if control_behavior.read_signal then
        table.insert(ans, "magn_glass")
    end
    return ans
end

local function wall_icons(control_behavior)
    local ans = {}
    if control_behavior.open_gate then
        table.insert(ans, "open_door")
    end
    if control_behavior.read_sensor then
        table.insert(ans, "magn_glass")
    end
    return ans
end

local resource_read_mode = {
    [defines.control_behavior.mining_drill.resource_read_mode.this_miner] = 'this_miner',
    [defines.control_behavior.mining_drill.resource_read_mode.entire_patch] = 'all'
}

local function drill_icons(control_behavior)
    local ans = {}
    if control_behavior.circuit_enable_disable then
        table.insert(ans, "enable_disable_icon")
    end
    if control_behavior.circuit_read_resources then
        table.insert(ans, resource_read_mode[control_behavior.resource_read_mode])
    end
    return ans
end


local icon_fetchers = {
    [defines.control_behavior.type.inserter] = inserter_icons,
    [defines.control_behavior.type.lamp] = lamp_icons,
    [defines.control_behavior.type.logistic_container] = logistic_container_icons,
    [defines.control_behavior.type.roboport] = roboport_icons,
    [defines.control_behavior.type.train_stop] = train_stop_icons,
    [defines.control_behavior.type.decider_combinator] = decider_icons,
    [defines.control_behavior.type.constant_combinator] = constant_combinator_icons,
    [defines.control_behavior.type.transport_belt] = belt_icons,
    [defines.control_behavior.type.rail_signal] = rail_signal_icons,
    [defines.control_behavior.type.wall] = wall_icons,
    [defines.control_behavior.type.mining_drill] = drill_icons

}

local function concat_icons(icons)
    local ans = ""
    for _, icon in pairs(icons) do
        ans = ans .. "[img=" .. icon .. "]"
    end
    return ans
end


function LABEL_ENTITIES(errors, entities)
    local max_level = {}
    for _, err in pairs(errors) do
        if max_level[err.index] == nil then
            max_level[err.index] = err.level
        elseif LEVELS[max_level[err.index]] < LEVELS[err.level] then
            max_level[err.index] = err.level
        end
    end
    for i, entity in pairs(entities) do
        local color = { 255, 255, 255 }
        if LEVEL_COLORS[max_level[i]] ~= nil then
            color = LEVEL_COLORS[max_level[i]]
        end
        local control_behaviour = entity.get_control_behavior()
        local fetcher = icon_fetchers[control_behaviour.type]
        local icons = {}
        if fetcher ~= nil then
            icons = fetcher(control_behaviour)
        end

        rendering.draw_text {
            text = i,
            surface = entity.surface,
            target = entity,
            color = color,
            only_in_alt_mode = true,
            alignment = "center",
            vertical_alignment = "top",
        }
        if table_size(icons) ~= 0 then
            local scale = 1
            if table_size(icons) > 2 then
                scale = 0.5
            end
            rendering.draw_text {
                text = concat_icons(icons),
                surface = entity.surface,
                target = entity,
                only_in_alt_mode = true,
                use_rich_text = true,
                alignment = "center",
                vertical_alignment = "bottom",
                color = color,
                scale = scale
            }
        end
    end
end
