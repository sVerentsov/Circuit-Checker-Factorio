require("utils")
require("log")

local function container_outputs(control_behavior)
    return { ["any-item"] = true }
end

local function generic_on_off_outputs(control_behavior)
    return {}
end

local function inserter_outputs(control_behavior)
    if control_behavior.circuit_read_hand_contents then
        return { ["any-item"] = true }
    else
        return {}
    end
end

local function lamp_outputs(control_behavior)
    return {}
end

local function logistic_container_outputs(control_behavior)
    if control_behavior.circuit_mode_of_operation == defines.control_behavior.logistic_container.circuit_mode_of_operation.send_contents then
        return { ["any-item"] = true }
    end
    return {}
end

local function is_roboport_read_logistics(control_behavior)
    if string.find(game.active_mods["base"], "1.") then
        return control_behavior.read_logistics
    else
        return control_behavior.mode_of_operations ==
            defines.control_behavior.roboport.circuit_mode_of_operation.read_logistics
    end
end

local function is_roboport_read_robot_stats(control_behavior)
    if string.find(game.active_mods["base"], "1.") then
        return control_behavior.read_robot_stats
    else
        return control_behavior.mode_of_operations ==
            defines.control_behavior.roboport.circuit_mode_of_operation.read_robot_stats
    end
end

local function roboport_outputs(control_behavior)
    local ans = {}
    if is_roboport_read_logistics(control_behavior) then
        ans["any-item"] = true
    end
    if is_roboport_read_robot_stats(control_behavior) then
        local any_output = false
        if control_behavior.available_logistic_output_signal ~= nil then
            any_output = true
            ans[control_behavior.available_logistic_output_signal.type] = true
            ans[GET_SIGNAL_TYPED_NAME(control_behavior.available_logistic_output_signal)] = true
        end
        if control_behavior.total_logistic_output_signal ~= nil then
            any_output = true
            ans[control_behavior.total_logistic_output_signal.type] = true
            ans[GET_SIGNAL_TYPED_NAME(control_behavior.total_logistic_output_signal)] = true
        end
        if control_behavior.available_construction_output_signal ~= nil then
            any_output = true
            ans[control_behavior.available_construction_output_signal.type] = true
            ans[GET_SIGNAL_TYPED_NAME(control_behavior.available_construction_output_signal)] = true
        end
        if control_behavior.total_construction_output_signal ~= nil then
            any_output = true
            ans[control_behavior.total_construction_output_signal.type] = true
            ans[GET_SIGNAL_TYPED_NAME(control_behavior.total_construction_output_signal)] = true
        end
        if not any_output then
            ans["blank"] = true
        end
    end
    return ans
end

local function storage_tank_outputs(control_behavior)
    return { ["any-fluid"] = true }
end

local function train_stop_outputs(control_behavior, entity)
    local ans = {}
    if control_behavior.read_from_train then
        for _, train in pairs(entity.get_train_stop_trains()) do
            if table_size(train.cargo_wagons) > 0 then
                ans["any-item"] = true
            end
            if table_size(train.fluid_wagons) > 0 then
                ans["any-fluid"] = true
            end
        end
    end
    if control_behavior.read_stopped_train then
        if control_behavior.stopped_train_signal ~= nil then
            ans[control_behavior.stopped_train_signal.type] = true
            ans[GET_SIGNAL_TYPED_NAME(control_behavior.stopped_train_signal)] = true
        else
            ans["blank"] = true
        end
    end
    if control_behavior.read_trains_count then
        if control_behavior.trains_count_signal ~= nil then
            ans[control_behavior.trains_count_signal.type] = true
            ans[GET_SIGNAL_TYPED_NAME(control_behavior.trains_count_signal)] = true
        else
            ans["blank"] = true
        end
    end
    return ans
end

local function decider_combinator_outputs(control_behavior)
    local ans = {}
    local params = control_behavior.parameters
    if params.output_signal ~= nil and params.output_signal.name ~= nil then
        ans[params.output_signal.type] = true
        ans[GET_SIGNAL_TYPED_NAME(params.output_signal)] = true
    else
        ans["blank"] = true
    end
    return ans
end

local function arithmetic_combinator_outputs(control_behavior)
    local ans = {}
    local params = control_behavior.parameters
    if params.output_signal ~= nil and params.output_signal.name ~= nil then
        ans[params.output_signal.type] = true
        ans[GET_SIGNAL_TYPED_NAME(params.output_signal)] = true
    else
        ans["blank"] = true
    end
    return ans
end

local function constant_combinator_outputs(control_behavior)
    if control_behavior.parameters == nil then
        return { ["blank"] = true }
    end
    local ans = {}
    local is_any = false
    for _, param in pairs(control_behavior.parameters) do
        if param ~= nil and param.signal ~= nil and param.signal.name ~= nil then
            is_any = true
            ans[param.signal.type] = true
            ans[GET_SIGNAL_TYPED_NAME(param.signal)] = true
        end
    end
    if not is_any then
        ans["blank"] = true
    end
    return ans
end

local function transport_belt_outputs(control_behavior)
    local ans = {}
    if control_behavior.read_contents then
        ans["any-item"] = true
    end
    return ans
end

local function accumulator_outputs(control_behavior)
    local ans = {}
    if control_behavior.output_signal ~= nil then
        ans[control_behavior.output_signal.type] = true
        ans[GET_SIGNAL_TYPED_NAME(control_behavior.output_signal)] = true
    else
        ans["blank"] = true
    end
    return ans
end

local function rail_signal_outputs(control_behavior)
    local ans = {}
    if control_behavior.read_signal then
        local any_output = false
        if control_behavior.red_signal ~= nil then
            any_output = true
            ans[control_behavior.red_signal.type] = true
            ans[GET_SIGNAL_TYPED_NAME(control_behavior.red_signal)] = true
        end
        if control_behavior.orange_signal ~= nil then
            any_output = true
            ans[control_behavior.orange_signal.type] = true
            ans[GET_SIGNAL_TYPED_NAME(control_behavior.orange_signal)] = true
        end
        if control_behavior.green_signal ~= nil then
            any_output = true
            ans[control_behavior.green_signal.type] = true
            ans[GET_SIGNAL_TYPED_NAME(control_behavior.green_signal)] = true
        end
        if not any_output then
            ans["blank"] = true
        end
    end
    return ans
end

local function rail_chain_signal_outputs(control_behavior)
    local ans = {}
    local any_output = false
    if control_behavior.red_signal ~= nil then
        any_output = true
        ans[control_behavior.red_signal.type] = true
        ans[GET_SIGNAL_TYPED_NAME(control_behavior.red_signal)] = true
    end
    if control_behavior.orange_signal ~= nil then
        any_output = true
        ans[control_behavior.orange_signal.type] = true
        ans[GET_SIGNAL_TYPED_NAME(control_behavior.orange_signal)] = true
    end
    if control_behavior.green_signal ~= nil then
        any_output = true
        ans[control_behavior.green_signal.type] = true
        ans[GET_SIGNAL_TYPED_NAME(control_behavior.green_signal)] = true
    end
    if control_behavior.blue_signal ~= nil then
        any_output = true
        ans[control_behavior.blue_signal.type] = true
        ans[GET_SIGNAL_TYPED_NAME(control_behavior.blue_signal)] = true
    end
    if not any_output then
        ans["blank"] = true
    end
    return ans
end

local function wall_outputs(control_behavior)
    local ans = {}
    if control_behavior.read_sensor then
        if control_behavior.output_signal ~= nil then
            ans[control_behavior.output_signal.type] = true
            ans[GET_SIGNAL_TYPED_NAME(control_behavior.output_signal)] = true
        else
            ans["blank"] = true
        end
    end
    return ans
end

local function mining_drill_outputs(control_behavior)
    local ans = {}
    if control_behavior.circuit_read_resources then
        ans["any-item"] = true
    end
    return ans
end

local function programmable_speaker_outputs(control_behavior)
    return {}
end



local output_fetchers = {
    [defines.control_behavior.type.container] = container_outputs,
    [defines.control_behavior.type.generic_on_off] = generic_on_off_outputs,
    [defines.control_behavior.type.inserter] = inserter_outputs,
    [defines.control_behavior.type.lamp] = lamp_outputs,
    [defines.control_behavior.type.logistic_container] = logistic_container_outputs,
    [defines.control_behavior.type.roboport] = roboport_outputs,
    [defines.control_behavior.type.storage_tank] = storage_tank_outputs,
    [defines.control_behavior.type.train_stop] = train_stop_outputs,
    [defines.control_behavior.type.decider_combinator] = decider_combinator_outputs,
    [defines.control_behavior.type.arithmetic_combinator] = arithmetic_combinator_outputs,
    [defines.control_behavior.type.constant_combinator] = constant_combinator_outputs,
    [defines.control_behavior.type.transport_belt] = transport_belt_outputs,
    [defines.control_behavior.type.accumulator] = accumulator_outputs,
    [defines.control_behavior.type.rail_signal] = rail_signal_outputs,
    [defines.control_behavior.type.rail_chain_signal] = rail_chain_signal_outputs,
    [defines.control_behavior.type.wall] = wall_outputs,
    [defines.control_behavior.type.mining_drill] = mining_drill_outputs,
    [defines.control_behavior.type.programmable_speaker] = programmable_speaker_outputs
}

function FETCH_OUTPUT(entity)
    local behavior = entity.get_control_behavior()
    LOG("control_behavior: " .. entity.prototype.name .. ": " .. BEHAVIOR_TYPES[behavior.type])
    local ans = output_fetchers[behavior.type](behavior, entity)
    if ENTITIES_ALLOW_NO_OUTPUTS[entity.prototype.name] ~= nil then
        ans['blank'] = false
    end
    if ENTITIES_MATCH_ALL_INPUT[entity.prototype.name] then
        ans['signal-anything:virtual'] = 1
    end

    ans["virtual"] = nil
    return ans
end
