local texlab_cap = vim.lsp.protocol.make_client_capabilities()
texlab_cap.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
texlab_cap.textDocument.publishDiagnostics = nil

return {
  capabilities = texlab_cap,
  cmd = { "texlab" },
  filetypes = { "tex", "bib" },
  settings = {
    texlab = {
      auxDirectory = "./tbuild",
      bibtexFormatter = "texlab",
      build = {
        executable = "latexmk",
        args = { "-lualatex", "-interaction=nonstopmode", "-synctex=1", "%f", "-output-directory=.texlab_build" },
        forwardSearchAfter = false,
        onSave = true
      },
      chktex = {
        onEdit = false,
        onOpenAndSave = true
      },
      formatterLineLength = 80,
      forwardSearch = {
        args = {}
      },
      latexFormatter = "latexindent",
      latexindent = {
        modifyLineBreaks = false
      }
    }
  },
  diagnostics = {
    ignoredPatterns = { ".*" }
  }
}
