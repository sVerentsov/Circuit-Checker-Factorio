require("consts")
require("signal_reader.input")
require("signal_reader.output")
require("utils.label_entities")
require("utils.gui")
require("utils.global")
require("checks")
require("log")
require("networks")

local function get_selected(event)
    if event.item ~= "circuit-checker" then
        return
    end
    local player = game.players[event.player_index]
    rendering.clear("circuit-checker")
    local circuit_entities = {}
    for _, entity in pairs(event.entities) do
        local behavior = entity.get_control_behavior()
        if behavior ~= nil then
            if not IGNORE_ENTITY(entity) then
                table.insert(circuit_entities, entity)
            end
        end
    end
    local errors = {}
    local networks = {}
    local entity_inputs = {}
    local entity_outputs = {}
    for i, entity in pairs(circuit_entities) do
        LOG("Processing entity " .. i)
        -- get possible inputs and outputs of entity
        local inputs = FETCH_INPUT(entity)
        entity_inputs[i] = inputs
        LOG(i .. " inputs: " .. entity.prototype.name .. " " .. serpent.line(inputs))
        local outputs = FETCH_OUTPUT(entity)
        entity_outputs[i] = outputs
        LOG(i .. " outputs: " .. entity.prototype.name .. " " .. serpent.line(outputs))

        -- check if required input/output signal settings are set up
        if inputs["blank"] == true then
            local msg = "message.no_input_set"
            if entity.get_control_behavior().type == defines.control_behavior.type.train_stop then
                msg = "message.no_input_set_trains"
            end
            table.insert(errors, {
                level = "E",
                index = i,
                entity = entity,
                msg = msg
            })
        end
        if outputs["blank"] == true then
            table.insert(errors, {
                level = "E",
                index = i,
                entity = entity,
                msg = "message.no_outputs"
            })
        end

        -- check if combinators are connected on input and output
        local io_errors = CHECK_IO(entity)
        for _, err in pairs(io_errors) do
            table.insert(errors, {
                level = "E",
                index = i,
                entity = entity,
                msg = err
            })
        end

        local entity_networks = GET_NETWORKS(entity, inputs, outputs)
        MERGE_NETWORKS(networks, entity_networks, i)
    end

    LOG(serpent.block(networks))

    for i, entity in pairs(circuit_entities) do
        LOG("checking entity " .. i)
        local entity_errors = CHECK_ENTITY(entity, entity_inputs[i], entity_outputs[i], networks)
        for _, err in pairs(entity_errors) do
            table.insert(errors, {
                level = err.level,
                index = i,
                entity = entity,
                msg = err.msg,
                params = err.params
            })
        end
    end
    if table_size(errors) == 0 then
        player.print({ "message.no_vulnerabilities", "[img=virtual-signal/signal-check]" })
    else
        SET_ERRORS(player.index, errors)
    end
    SHOW_GUI(errors, player)
    LABEL_ENTITIES(errors, circuit_entities)
end

script.on_event(defines.events.on_player_selected_area, get_selected)
script.on_configuration_changed(function(e)
    CLOSE_ALL_GUI()
end)
