return {
  "nvim-mini/mini.move",
  version = false,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    mappings = {
      left = "H",
      right = "L",
      down = "J",
      up = "K",
      line_left = "H",
      line_right = "L",
      line_down = "J",
      line_up = "K",
    },
  },
}
