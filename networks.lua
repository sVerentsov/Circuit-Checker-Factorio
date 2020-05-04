require("consts")
function GET_NETWORKS(entity, inputs, outputs)
    -- returns table network_id -> {input -> {signal -> true}, output -> {signal-> true}}
    local ans = {}
    if IO_SEPARATED[entity.get_control_behavior().type] then
        for _, wire in pairs(WIRES) do
            local network = entity.get_circuit_network(wire, defines.circuit_connector_id.combinator_input)
            if network ~= nil then 
                ans[network.network_id] = {
                    input = inputs,
                    output = {}
                }
            end
            network = entity.get_circuit_network(wire, defines.circuit_connector_id.combinator_output)
            if network ~= nil then
                if ans[network.network_id] ~= nil then 
                    ans[network.network_id]["output"] = outputs
                else 
                    ans[network.network_id] = {
                        input = {},
                        output = outputs
                    }
                end
            end
        end
    else
        for _, wire in pairs(WIRES) do
            local network = entity.get_circuit_network(wire)
            if network ~= nil then 
                ans[network.network_id] = {
                    input = inputs,
                    output = outputs
                }
            end
        end
    end
    return ans
end

function MERGE_NETWORKS(networks, entity_networks, entity_id)
    for id, network in pairs(entity_networks) do
        if networks[id] == nil then
            networks[id] = {input = {}, output = {}}
        end
        for signal, _ in pairs(network.input) do
            if networks[id].input[signal] == nil then
                networks[id].input[signal] = {entity_id}
            else
                table.insert(networks[id].input[signal], entity_id)
            end
        end
        for signal, _ in pairs(network.output) do
            if networks[id].output[signal] == nil then
                networks[id].output[signal] = {entity_id}
            else
                table.insert(networks[id].output[signal], entity_id)
            end
        end
    end
end

function GET_CONNECTED_NETWORKS(entity)
    -- returns table in format {input -> {network_id -> true}, output -> {network_id -> true}}
    local connected_networks = {input = {}, output = {}}
    if IO_SEPARATED[entity.get_control_behavior().type] then
        for _, wire in pairs(WIRES) do
            local network = entity.get_circuit_network(wire, defines.circuit_connector_id.combinator_input)
            if network ~= nil then
                connected_networks.input[network.network_id] = true
            end
        end
        for _, wire in pairs(WIRES) do
            local network = entity.get_circuit_network(wire, defines.circuit_connector_id.combinator_output)
            if network ~= nil then
                connected_networks.output[network.network_id] = true
            end
        end
    else
        for _, wire in pairs(WIRES) do
            local network = entity.get_circuit_network(wire)
            if network ~= nil then
                connected_networks.input[network.network_id] = true
                connected_networks.output[network.network_id] = true
            end
        end
    end
    return connected_networks
end