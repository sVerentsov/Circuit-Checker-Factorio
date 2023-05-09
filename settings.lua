data:extend({
  {
    type = "bool-setting",
    name = "circuit-checker-enable-logging",
    setting_type = "runtime-global",
    default_value = true
  },
  {
    type = "string-setting",
    name = "circuit-checker-checker-mode",
    setting_type = "runtime-per-user",
    default_value = "dont-show-errors",
    allowed_values = { "no", "yes", "dont-show-errors" }
  }
})
