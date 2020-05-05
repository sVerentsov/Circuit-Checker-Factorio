require("consts")
require("signal_reader.input")
require("signal_reader.output")
require("checks")
require("log")
require("networks")

local function print_errors(errors, player)
    for _, err in pairs(errors) do
        LOG(serpent.line(err))
        local str = ""
        if LEVEL_COLORS[err.level] ~= nil then
            str = str .. "[color=" ..
                LEVEL_COLORS[err.level][1] .. "," ..
                LEVEL_COLORS[err.level][2] .. "," ..
                LEVEL_COLORS[err.level][3] ..
                "]" .. err.level .. "[/color]: "
        else 
            str = str .. err.level .. ": "
        end
        player.print(str ..
            "[img=entity/" .. err.entity.prototype.name .. "] " ..
            err.index .. ": "..
            err.msg
        )
    end
end

local function label_entities(errors, entities)
    local max_level = {}
    for _, err in pairs(errors) do 
        if max_level[err.index] == nil then
            max_level[err.index] = err.level
        elseif LEVELS[max_level[err.index]] < LEVELS[err.level] then
            max_level[err.index] = err.level
        end
    end
    for i, entity in pairs(entities) do
        local color = {255, 255, 255} 
        if LEVEL_COLORS[max_level[i]] ~= nil then
            color = LEVEL_COLORS[max_level[i]]
        end
        rendering.draw_text{text=i,
            surface="nauvis", -- TODO take surface from event (0.18)
            target=entity,
            color=color,
            only_in_alt_mode=true
        }
    end
end

local function get_selected(event)
    local player = game.players[event.player_index]
    rendering.clear("circuit-checker")
    local circuit_entities = {}
    for _, entity in pairs(event.entities) do
        local behavior = entity.get_control_behavior()
        if behavior ~= nil then
            table.insert(circuit_entities, entity)
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
            local msg = "One or more inputs not set"
            if entity.get_control_behavior().type == defines.control_behavior.type.train_stop then
                msg = "One or more inputs not set. Check assigned trains"
            end
            table.insert(errors, {level = "E", index = i, entity = entity, msg = msg})
        end
        if outputs["blank"] == true then
            table.insert(errors, {level = "E", index = i, entity = entity, msg = "Output not set"})
        end

        -- check if combinators are connected on input and output
        local io_errors = CHECK_IO(entity)
        for _, err in pairs(io_errors) do
            table.insert(errors, {level = "E", index = i, entity = entity, msg = err})
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
                msg = err.msg
            })
        end
    end
    print_errors(errors, player)
    label_entities(errors, circuit_entities)
end

script.on_event(defines.events.on_player_selected_area, get_selected)


