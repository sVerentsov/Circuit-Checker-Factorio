require("consts")
require("log")
function CHECK_IO(entity)
    local errors = {}
    if IO_SEPARATED[entity.get_control_behavior().type] ~= nil then
        local has_input = false
        local has_output = false
        for _, wire in pairs(WIRES) do 
            if entity.get_circuit_network(wire, defines.circuit_connector_id.combinator_input) ~= nil then 
                has_input = true
            end
            if entity.get_circuit_network(wire, defines.circuit_connector_id.combinator_output) ~= nil then 
                has_output = true
            end
        end
        if not has_input then
            table.insert(errors, "No input wires")
        end
        if not has_output then
            table.insert(errors, "No output wires")
        end
    end
    return errors
end

local function is_input_matched(input, outputs)
    if SIGNALS_MATCH_ANYTHING[input] then
        return true
    end
    for signal, _ in pairs(SIGNALS_MATCH_ANYTHING) do
        if outputs[signal] then
            return true
        end
    end
    -- if blank, virtual, fluid, item do not warn
    if input == "blank" or TYPES[input] then
        return true
    end
    if outputs[input] ~= nil then
        return true
    end
    -- if output contains any-item and input is an item. For example, chest -> combinator with condition on iron plates
    if outputs["any-item"] ~= nil and GET_SIGNAL_TYPE(input) == "item" then
        return true
    end
    -- if output contains any-fluid and input is a fluid. For example, storage tank -> combinator with condition on lubricant.
    if outputs["any-fluid"] ~= nil and GET_SIGNAL_TYPE(input) == "fluid" then
        return true
    end
    -- if output contains concrete item and input is any item. For example, constant combinator -> set filter in inserter.
    if outputs["item"] ~= nil and input == "any-item" then
        return true 
    end
    return false
end

local function is_output_matched(output, inputs)
    -- if output is signal-each, signal-anything, signal-everything
    if SIGNALS_MATCH_ANYTHING[output] then
        return true
    end
    -- if inputs contain signal-each, signal-anything, signal-everything
    for signal, _ in pairs(SIGNALS_MATCH_ANYTHING) do
        if inputs[signal] then
            return true
        end
    end
    -- if blank, virtual, fluid or item, do not warn
    if output == "blank" or TYPES[output] then
        return true
    end
    -- if inputs contain exactly output
    if inputs[output] ~= nil then
        return true
    end
    -- if inputs have any-item, and output is concrete item, for example, constant-combinator -> inserter with "Set filter" mode
    if inputs["any-item"] ~= nil and GET_SIGNAL_TYPE(output) == "item" then
        return true
    end
    -- No check for any-fluid, since nothing takes any fluid as input
    -- if output is any-item and input contain some concrete item. For example, chest -> combinator with condition on iron plates
    if output == "any-item" and inputs["item"] ~= nil then
        return true
    end
    -- if output is any-fluid and input contains a fluid. For example, storage tank -> combinator with condition on lubricant.
    if output == "any-fluid" and inputs["fluid"] ~= nil then
        return true
    end
    -- if output is color and input contains "color" (lamp with "Use colors" mode)
    if COLORS[output] and inputs["color"] ~= nil then
        return true
    end
    return false
end

local function contain_color(outputs)
    for signal, _ in pairs(outputs) do
        if COLORS[signal] or SIGNALS_MATCH_ANYTHING[signal] then
            return true
        end
    end
    return false
end

function CHECK_ENTITY(entity, entity_inputs, entity_outputs, networks)
    local errors = {}
    -- get list of connected networks to entity
    local connected_networks = GET_CONNECTED_NETWORKS(entity)
    LOG("connected_networks: " .. serpent.line(connected_networks))
    -- check inputs
    for signal, _ in pairs(entity_inputs) do
        -- check if signal is matched at at least one network
        local matched = false
        for network_id, _ in pairs(connected_networks.input) do
            if signal == "color" then
                matched = true
                if not contain_color(networks[network_id].output) then
                    table.insert(errors,
                    {
                        level="I",
                        msg='"Use colors" is enabled but no color output is found'
                    })
                end
            else
                if is_input_matched(signal, networks[network_id].output) then
                    matched = true
                end
            end
        end
        -- if not matched, create error.
        if not matched then
            table.insert(errors,
            {
                level="E",
                msg="Input " .. GET_PRETTY_SIGNAL(signal) .. " is required, but there is no such output in connected networks"
            })
        end
    end
    -- check outputs
    for signal, _ in pairs(entity_outputs) do
        LOG(signal)
        -- check if signal is matched at at least one network
        local matched = false
        for network_id, _ in pairs(connected_networks.output) do 
            if is_output_matched(signal, networks[network_id].input) then
                matched = true
            end
        end
        -- if not matched, create warning.
        if not matched then
            table.insert(errors,
            {
                level="W",
                msg="Output " .. GET_PRETTY_SIGNAL(signal) .. " is unused"
            })
        end
    end
    return errors
end
