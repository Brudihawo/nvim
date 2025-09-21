return {
  filetypes = { "rust" },
  cmd = { "rust-analyzer" },
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },
      cargo = {
        loadOutDirsFromCheck = true,
        allFeatures = true,
        ["buildScripts.enable"] = true
      },
      procMacro = {
        enable = true,
      },
      inlayHints = {
        ["chainingHints.enable"] = true,
        auto = true,
        show_parameter_hints = true,
        closingBraceHints = {
          minLines = 4,
          enable = true
        },
        ["typeHints.enable"] = true
      }
    }
  }
}
