IO_SEPARATED = {
    -- set of control behaviors of entities, whose input and outputs are separated
    [defines.control_behavior.type.decider_combinator] = true,
    [defines.control_behavior.type.arithmetic_combinator] = true
}

WIRES = {
    defines.wire_type.green,
    defines.wire_type.red
}

LEVEL_COLORS = {
    E = { 255, 66, 66 },
    W = { 237, 232, 97 }
}

LEVELS = {
    E = 4,
    W = 3,
    I = 2
}

TYPES = {
    ["virtual"] = true,
    ["item"] = true,
    ["fluid"] = true
}

SIGNALS_MATCH_ANYTHING = {
    ["signal-each:virtual"] = true,
    ["signal-anything:virtual"] = true,
    ["signal-everything:virtual"] = true
}

COLORS = {
    ["signal-blue:virtual"] = true,
    ["signal-cyan:virtual"] = true,
    ["signal-green:virtual"] = true,
    ["signal-pink:virtual"] = true,
    ["signal-red:virtual"] = true,
    ["signal-white:virtual"] = true,
    ["signal-yellow:virtual"] = true
}

CB_DISALLOW_NO_WIRES = {
    [defines.control_behavior.type.programmable_speaker] = true,
    [defines.control_behavior.type.constant_combinator] = true,
    [defines.control_behavior.type.arithmetic_combinator] = true,
    [defines.control_behavior.type.decider_combinator] = true
}

ENTITIES_ALLOW_NO_OUTPUTS = {
    ['hud-combinator'] = 1
}

ENTITIES_ALLOW_NO_INPUTS = {
}

ENTITIES_IGNORE_IF_NO_WIRES = {
    ["nixie-tube-small"] = 1,
    ["nixie-tube-alpha"] = 1,
    ['nixie-tube'] = 1
}

ENTITIES_MATCH_ALL_INPUT = {
}

ENTITIES_MATCH_ALL_OUTPUT = {
    ["hud-combinator"] = 1
}
