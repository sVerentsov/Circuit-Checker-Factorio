local function icon_prototype(name)
    local offset = 6
    local y_offset = 10
    return {
        type = "sprite",
        filename = "__circuit-checker__/graphics/" .. name .. ".png",
        flags = {
            "gui-icon"
        },
        height = 64 - 2 * y_offset,
        mipmap_count = 1,
        name = name,
        scale = 1,
        width = 64 - 2 * offset,
        x = offset,
        y = y_offset
    }
end

data:extend({
    icon_prototype "enable_disable_icon",
    icon_prototype "read_hand_icon",
    icon_prototype "set_filter_icon",
    icon_prototype "hold_icon",
    icon_prototype "pulse_icon",
    icon_prototype "set_stack_size",

    icon_prototype "use_colors",

    icon_prototype "send_contents",
    icon_prototype "set_requests",

    icon_prototype "read_robot_stats",

    icon_prototype "send_to_train",
    icon_prototype "read_from_train",
    icon_prototype "read_stopped_train",
    icon_prototype "set_trains_limit",
    icon_prototype "read_trains_count",

    icon_prototype "output_one",

    icon_prototype "disabled",

    icon_prototype "magn_glass",
    icon_prototype "stop_icon",

    icon_prototype "open_door",

    icon_prototype "all",
    icon_prototype "this_miner",
})
