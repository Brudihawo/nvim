return {
  setup = function()
    require('blame').setup {
      views = { "window" },
      date_format = "%H:%M %d.%m.%Y",
      virtual_style = "right_align"
    }
  end
}
