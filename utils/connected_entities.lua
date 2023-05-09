function GET_CIRCUIT_ENTITES(entities, checker_mode)
    local visited
    local selected_ids = {}
    for _, entity in pairs(entities) do
        selected_ids[entity.unit_number] = true
    end
    if checker_mode ~= "no" then
        visited = {}
        local to_visit = {}
        for _, entity in pairs(entities) do
            if entity.circuit_connected_entities then
                to_visit[entity.unit_number] = entity
            end
        end
        while table_size(to_visit) > 0 do
            local current
            for _, entity in pairs(to_visit) do
                current = entity
                to_visit[entity.unit_number] = nil
                break
            end
            if not visited[current.unit_number] then
                visited[current.unit_number] = current
                for _, wire_entities in pairs(current.circuit_connected_entities) do
                    for _, connected_entity in pairs(wire_entities) do
                        if (not visited[connected_entity.unit_number])
                            and (not to_visit[connected_entity.unit_number])
                        then
                            to_visit[connected_entity.unit_number] = connected_entity
                        end
                    end
                end
            end
        end
    else
        visited = entities
    end
    local result = {
        visible = {},
        checkable = {}
    }
    -- include only entities with control behavior
    for _, entity in pairs(visited) do
        local behavior = entity.get_control_behavior()
        if behavior ~= nil then
            if not IGNORE_ENTITY(entity) then
                table.insert(result.checkable, entity)
                if checker_mode == "yes" or selected_ids[entity.unit_number] then
                    result.visible[entity.unit_number] = true
                end
            end
        end
    end
    return result
end
