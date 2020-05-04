data:extend({
    {
      type = "selection-tool",
      name = "circuit-checker",
      icon = "__base__/graphics/icons/info.png",
      icon_size = 32,
      stack_size = 1,
      subgroup = "tool",
      selection_color = {r = 0.2, g = 0.8, b = 0.2, a = 0.2},
      alt_selection_color = {r = 0.2, g = 0.2, b = 0.8, a = 0.2},
      selection_mode = {"blueprint"},
      always_include_tiles = true,
      alt_selection_mode = {"blueprint"},
      selection_cursor_box_type = "entity",
      alt_selection_cursor_box_type = "copy",
      show_in_library = true
    }
}
)