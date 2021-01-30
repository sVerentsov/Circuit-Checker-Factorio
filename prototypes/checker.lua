data:extend({
    {
      type = "selection-tool",
      name = "circuit-checker",
      icon = "__circuit-checker__/graphics/icon-small.png",
      icon_size = 32,
      stack_size = 1,
      subgroup = "tool",
      selection_color = {r = 0.2, g = 0.8, b = 0.2, a = 0.2},
      alt_selection_color = {r = 0.2, g = 0.2, b = 0.8, a = 0.2},
      selection_mode = {"blueprint"},
      alt_selection_mode = {"blueprint"},
      selection_cursor_box_type = "entity",
      alt_selection_cursor_box_type = "copy",
      flags = {
        "hidden",
        "not-stackable",
        "only-in-cursor",
        "spawnable"
      }
    },
    {
      action = "spawn-item",
      associated_control_input = "give-circuit-checker",
      disabled_small_icon = {
        filename = "__circuit-checker__/graphics/icon-small.png",
        flags = {
          "icon"
        },
        mipmap_count = 2,
        priority = "extra-high-no-scale",
        scale = 0.5,
        size = 24
      },
      icon = {
        filename = "__circuit-checker__/graphics/icon-small.png",
        flags = {
          "icon"
        },
        mipmap_count = 2,
        priority = "extra-high-no-scale",
        scale = 0.5,
        size = 32
      },
      item_to_spawn = "circuit-checker",
      localised_name = {
        "shortcut.name"
      },
      name = "check-circuit",
      small_icon = {
        filename = "__circuit-checker__/graphics/icon-small.png",
        flags = {
          "icon"
        },
        mipmap_count = 2,
        priority = "extra-high-no-scale",
        scale = 0.5,
        size = 24
      },
      style = "green",
      technology_to_unlock = "circuit-network",
      type = "shortcut"
    },
    {
      action = "spawn-item",
      consuming = "game-only",
      item_to_spawn = "circuit-checker",
      key_sequence = "ALT + C",
      name = "give-circuit-checker",
      type = "custom-input"
    }
}
)