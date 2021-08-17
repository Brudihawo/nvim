local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true;
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

require("lspconfig").pylsp.setup{
  capabilities = capabilities,
  -- on_attach = require('lsp_signature').on_attach("pylsp"),
  settings = {
    pylsp = {
      configurationSources = { "flake8" },
      plugins = {
        pydocstyle = {
          enabled = true,
          convention = 'google'
        },
        jedi_completion = {
          enabled = true,
          fuzzy = true,
          eager = true
        },
        black = {
          enabled = true,
          args = {
            '-l', '80'
          }
        },
        flake8 = {
          enabled = true,
          args = { "--ignore=E203,W503" },
        }
      }
    }
  }
}

require("lspconfig").rls.setup{
  capabilities = capabilities,
}


require("lspconfig").texlab.setup{
  capabilities = capabilities,
  cmd = { "texlab" },
  filetypes = { "tex", "bib" },
  settings = {
    texlab = {
      auxDirectory = ".",
      bibtexFormatter = "texlab",
      build = {
        args = { "-lualatex", "-interaction=nonstopmode", "-synctex=1", "%f" },
        executable = "latexmk",
        forwardSearchAfter = false,
        onSave = false
      },
      chktex = {
        onEdit = false,
        onOpenAndSave = false
      },
      diagnosticsDelay = 300,
      formatterLineLength = 80,
      forwardSearch = {
        args = {}
      },
      latexFormatter = "latexindent",
      latexindent = {
        modifyLineBreaks = false
      }
    }
  }
}

require("lspconfig").ccls.setup{
  capabilities = capabilities,
  -- on_attach = require('lsp_signature').on_attach("ccls"),
  init_options = {
    index = {
      threads = 0;
    },
    cache = {
      directory = "/tmp/ccls";
    },
  },
  rootPatterns = { ".ccls", "compile_commands.json", ".git/", ".hg/" },
  filetypes = { "c", "cc", "cpp", "c++", "objc", "objcpp", "h", "hpp" },
}
require("lspconfig").cmake.setup{
  capabilities = capabilities,
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false;
        underline=true;
    }
)


local saga = require('lspsaga')
saga.init_lsp_saga {
  max_preview_lines = 20,
  finder_action_keys = {
    open = 'o', vsplit = 's',split = 'i',quit = 'q',scroll_down = '<C-f>', scroll_up = '<C-b>' -- quit can be a table
  },
}

require("lsp-colors").setup({
  Error = "#cc241d",
  Warning = "#d79921",
  Information = "#b16286",
  Hint = "#689d6a"
})

-- Set lsp diagnostic signs
vim.api.nvim_command("sign define LspDiagnosticsSignError text=\\ ☠")
vim.api.nvim_command("sign define LspDiagnosticsSignWarning text=⚠")
vim.api.nvim_command("sign define LspDiagnosticsSignInformation text=ⓘ")
vim.api.nvim_command("sign define lspLspDiagnosticsSignHint text=⚐")

return {
  print_response = function(err, method, result, client_id, bufnr, config)
    print("Config: " .. vim.inspect(config) .. " " ..
          "Method: " .. vim.inspect(method) .. " " ..
          "Result: " .. vim.inspect(result))
  end
}

