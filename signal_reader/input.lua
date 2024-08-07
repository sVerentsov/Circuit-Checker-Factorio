require("utils")
require("log")

local function container_inputs(control_behavior)
    return {} -- container can not use signals, only output them
end

local function one_condition_input(signal, constant)
    local ans = {}
    if signal == nil or signal.name == nil then
        if constant == nil then
            ans["blank"] = true
        end
    else
        ans[GET_SIGNAL_TYPED_NAME(signal)] = true
        ans[signal.type] = true
    end
    return ans
end

local function condition_inputs(condition)
    local ans = {}
    local inp1 = one_condition_input(condition.first_signal, nil)
    for k, v in pairs(inp1) do ans[k] = v end
    local inp2 = one_condition_input(condition.second_signal, condition.constant)
    for k, v in pairs(inp2) do ans[k] = v end
    return ans
end

local function generic_on_off_inputs(control_behavior)
    local condition = control_behavior.circuit_condition.condition
    return condition_inputs(condition)
end

local function inserter_inputs(control_behavior)
    local ans = {}
    LOG("Inserter: " .. INSERTER_MODES[control_behavior.circuit_mode_of_operation])
    if control_behavior.circuit_mode_of_operation == defines.control_behavior.inserter.circuit_mode_of_operation.enable_disable then
        for k, v in pairs(generic_on_off_inputs(control_behavior)) do ans[k] = v end
    elseif control_behavior.circuit_mode_of_operation == defines.control_behavior.inserter.circuit_mode_of_operation.set_filters then
        ans["any-item"] = true
    end
    if control_behavior.circuit_set_stack_size then
        if control_behavior.circuit_stack_control_signal == nil then
            ans["blank"] = true
        else
            ans[GET_SIGNAL_TYPED_NAME(control_behavior.circuit_stack_control_signal)] = true
            ans[control_behavior.circuit_stack_control_signal.type] = true
        end
    end
    return ans
end

local function lamp_inputs(control_behavior)
    local ans = generic_on_off_inputs(control_behavior)
    if control_behavior.use_colors then
        ans["color"] = true
    end
    return ans
end

local function logistic_container_inputs(control_behavior)
    if control_behavior.circuit_mode_of_operation == defines.control_behavior.logistic_container.circuit_mode_of_operation.set_requests then
        return { ["any-item"] = true }
    end
    return {}
end

local function roboport_inputs(control_behavior)
    return {}
end

local function storage_tank_inputs(control_behavior)
    return {}
end

local function train_stop_inputs(control_behavior, entity)
    local ans = {}
    if control_behavior.enable_disable then
        for k, v in pairs(generic_on_off_inputs(control_behavior)) do ans[k] = v end
    end
    if control_behavior.set_trains_limit then
        if control_behavior.trains_limit_signal == nil then
            ans["blank"] = true
        else
            ans[GET_SIGNAL_TYPED_NAME(control_behavior.trains_limit_signal)] = true
            ans[control_behavior.trains_limit_signal.type] = true
        end
    end
    if control_behavior.send_to_train then
        -- find all trains with this station, get their circuit conditions and get inputs of those conditions
        for _, train in pairs(entity.get_train_stop_trains()) do
            for _, record in pairs(train.schedule.records) do
                if record.station == entity.backer_name then
                    if record.wait_conditions ~= nil then
                        for _, condition in pairs(record.wait_conditions) do
                            if condition.type == "circuit" then
                                if condition.condition == nil then
                                    ans["blank"] = true
                                else
                                    for k, v in pairs(condition_inputs(condition.condition)) do ans[k] = v end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return ans
end

local function decider_combinator_inputs(control_behavior)
    local condition = control_behavior.parameters
    local ans = condition_inputs(condition)
    if condition.output_signal ~= nil and condition.output_signal.name ~= nil then
        if condition.output_signal.name == "signal-everything" or condition.output_signal.name == "signal-each" then
            ans[GET_SIGNAL_TYPED_NAME(condition.output_signal)] = true
            ans[condition.output_signal.type] = true
        end
        if condition.copy_count_from_input then
            if condition.first_signal.name ~= "signal-each" then
                ans[GET_SIGNAL_TYPED_NAME(condition.output_signal)] = true
                ans[condition.output_signal.type] = true
            end
        end
    end
    return ans
end

local function arithmetic_combinator_inputs(control_behavior)
    local condition = control_behavior.parameters
    local ans = {}
    local inp1 = one_condition_input(condition.first_signal, condition.first_constant)
    for k, v in pairs(inp1) do ans[k] = v end
    local inp2 = one_condition_input(condition.second_signal, condition.second_constant)
    for k, v in pairs(inp2) do ans[k] = v end
    return ans
end

local function constant_combinator_inputs(control_behavior)
    return {}
end

local function transport_belt_inputs(control_behavior)
    local ans = {}
    if control_behavior.enable_disable then
        ans = generic_on_off_inputs(control_behavior)
    end
    return ans
end

local function accumulator_inputs(control_behavior)
    return {}
end

local function rail_signal_inputs(control_behavior)
    local ans = {}
    if control_behavior.close_signal then
        ans = condition_inputs(control_behavior.circuit_condition.condition)
    end
    return ans
end

local function rail_chain_signal_inputs(control_behavior)
    return {}
end

local function wall_inputs(control_behavior)
    local ans = {}
    if control_behavior.open_gate then
        ans = condition_inputs(control_behavior.circuit_condition.condition)
    end
    return ans
end

local function mining_drill_inputs(control_behavior)
    local ans = {}
    if control_behavior.circuit_enable_disable then
        ans = generic_on_off_inputs(control_behavior)
    end
    return ans
end

local function programmable_speaker_inputs(control_behavior)
    return condition_inputs(control_behavior.circuit_condition.condition)
end

local input_fetchers = {
    [defines.control_behavior.type.container] = container_inputs,
    [defines.control_behavior.type.generic_on_off] = generic_on_off_inputs,
    [defines.control_behavior.type.inserter] = inserter_inputs,
    [defines.control_behavior.type.lamp] = lamp_inputs,
    [defines.control_behavior.type.logistic_container] = logistic_container_inputs,
    [defines.control_behavior.type.roboport] = roboport_inputs,
    [defines.control_behavior.type.storage_tank] = storage_tank_inputs,
    [defines.control_behavior.type.train_stop] = train_stop_inputs,
    [defines.control_behavior.type.decider_combinator] = decider_combinator_inputs,
    [defines.control_behavior.type.arithmetic_combinator] = arithmetic_combinator_inputs,
    [defines.control_behavior.type.constant_combinator] = constant_combinator_inputs,
    [defines.control_behavior.type.transport_belt] = transport_belt_inputs,
    [defines.control_behavior.type.accumulator] = accumulator_inputs,
    [defines.control_behavior.type.rail_signal] = rail_signal_inputs,
    [defines.control_behavior.type.rail_chain_signal] = rail_chain_signal_inputs,
    [defines.control_behavior.type.wall] = wall_inputs,
    [defines.control_behavior.type.mining_drill] = mining_drill_inputs,
    [defines.control_behavior.type.programmable_speaker] = programmable_speaker_inputs
}

local on_off_inherited = {
    [defines.control_behavior.type.generic_on_off] = 1,
    [defines.control_behavior.type.inserter] = 1,
    [defines.control_behavior.type.lamp] = 1,
    [defines.control_behavior.type.train_stop] = 1,
    [defines.control_behavior.type.transport_belt] = 1,
    [defines.control_behavior.type.mining_drill] = 1
}

function FETCH_INPUT(entity)
    local behavior = entity.get_control_behavior()
    LOG("control_behavior: " .. entity.prototype.name .. ": " .. BEHAVIOR_TYPES[behavior.type])
    local ans = input_fetchers[behavior.type](behavior, entity)
    if ENTITIES_ALLOW_NO_INPUTS[entity.prototype.name] ~= nil then
        ans['blank'] = false
    end
    if ENTITIES_MATCH_ALL_OUTPUT[entity.prototype.name] then
        ans['signal-anything:virtual'] = 1
    end
    ans["virtual"] = nil
    return ans
end

local function has_wires(entity)
    local result = false
    for _, wire in pairs(WIRES) do
        if entity.get_circuit_network(wire) then
            result = true
        end
    end
    return result
end

function IGNORE_ENTITY(entity)
    local behavior = entity.get_control_behavior()

    -- if no io is allowed (for modded entities) and no wires connected, ignore this entity
    if ENTITIES_IGNORE_IF_NO_WIRES[entity.prototype.name] ~= nil and not has_wires(entity) then
        return true
    end
    -- if no wires are allowed for this entity and it is not connected to circuit, ignore
    return CB_DISALLOW_NO_WIRES[behavior.type] == nil and not has_wires(entity)
end
