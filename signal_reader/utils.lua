BEHAVIOR_TYPES = {
    [defines.control_behavior.type.container] = "container",
    [defines.control_behavior.type.generic_on_off] = "generic_on_off",
    [defines.control_behavior.type.inserter] = "inserter",
    [defines.control_behavior.type.lamp] = "lamp",
    [defines.control_behavior.type.logistic_container] = "logistic_container",
    [defines.control_behavior.type.roboport] = "roboport",
    [defines.control_behavior.type.storage_tank] = "storage_tank",
    [defines.control_behavior.type.train_stop] = "train_stop",
    [defines.control_behavior.type.decider_combinator] = "decider_combinator",
    [defines.control_behavior.type.arithmetic_combinator] = "arithmetic_combinator",
    [defines.control_behavior.type.constant_combinator] = "constant_combinator",
    [defines.control_behavior.type.transport_belt] = "transport_belt",
    [defines.control_behavior.type.accumulator] = "accumulator",
    [defines.control_behavior.type.rail_signal] = "rail_signal",
    [defines.control_behavior.type.rail_chain_signal] = "rail_chain_signal",
    [defines.control_behavior.type.wall] = "wall",
    [defines.control_behavior.type.mining_drill] = "mining_drill",
    [defines.control_behavior.type.programmable_speaker] = "programmable_speaker",
}

INSERTER_MODES = {
    [defines.control_behavior.inserter.circuit_mode_of_operation.none] = "none",
    [defines.control_behavior.inserter.circuit_mode_of_operation.enable_disable] = "enable_disable",
    [defines.control_behavior.inserter.circuit_mode_of_operation.set_filters] = "set_filters",
    [defines.control_behavior.inserter.circuit_mode_of_operation.read_hand_contents] = "read_hand_contents",
    [defines.control_behavior.inserter.circuit_mode_of_operation.set_stack_size] = "set_stack_size"
}

function GET_SIGNAL_TYPED_NAME(signal)
    -- returns name of signal in form "advanced-circuit:item"
    return signal.name .. ":" .. signal.type
end

function GET_SIGNAL_TYPE(signal_typed_name)
    -- returns type of signal: from "advanced-circuit:item" returns item
    local pos, _ = string.find(signal_typed_name, ":")
    if pos == nil then 
        -- if nil, then whole name is type
        return signal_typed_name
    end
    return string.sub(signal_typed_name, pos+1)
end

function GET_PRETTY_SIGNAL(signal_typed_name)
    local pos, _ = string.find(signal_typed_name, ":")
    if pos == nil then 
        -- if nil, then whole name is type
        return "[font=default-bold]" .. signal_typed_name .. "[/font]"
    end
    local type_ = string.sub(signal_typed_name, pos+1)
    if type_ == "virtual" then
        type_ = "virtual-signal"
    end
    return "[img=" .. type_ ..  "/"
        .. string.sub(signal_typed_name, 1, pos-1) .. "]"
end