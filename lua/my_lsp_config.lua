local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

require("lspconfig").pylsp.setup {
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
        pyls_isort = {
          enabled = true
        },
        jedi_completion = {
          enabled = true,
          fuzzy = true,
          eager = true
        },
        black = {
          enabled = true,
          args = {
            '-l', '90'
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

require("lspconfig").rust_analyzer.setup {
  capabilities = capabilities,
  settings = {
        ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },
      cargo = {
        loadOutDirsFromCheck = true,
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

require 'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

local arduino_ls_capabilities = vim.lsp.protocol.make_client_capabilities()
arduino_ls_capabilities.semanticTokensProvider = nil

-- arduino_ls_capabilities.textDocument.completion.completionItem.resolveSupport = {
--   properties = {
--     'documentation',
--     'detail',
--   }
-- }
require 'lspconfig'.arduino_language_server.setup {
  on_attach = function(client)
    client.server_capabilities.semanticTokensProvider = nil
  end,
  cmd = {
    "/usr/bin/arduino-language-server",
    "-cli-config", "/home/hawo/.arduino15/arduino-cli.yaml",
    "-cli", "/home/hawo/.local/bin/arduino-cli",
    "-clangd", "/usr/bin/clangd",
    "-fqbn", "esp32:esp32:lolin32-lite",
  }
}

local texlab_cap = vim.lsp.protocol.make_client_capabilities()
texlab_cap.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
texlab_cap.textDocument.publishDiagnostics = nil

require("lspconfig").texlab.setup {
  capabilities = capabilities,
  cmd = { "texlab" },
  filetypes = { "tex", "bib" },
  settings = {
    texlab = {
      auxDirectory = "./tbuild",
      bibtexFormatter = "texlab",
      build = {
        executable = "latexmk",
        args = { "-lualatex", "-interaction=nonstopmode", "-synctex=1", "%f", "-output-directory=.texlab_build"},
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
    ignoredPatterns = {".*"}
  }
}

require("lspconfig").clangd.setup {
  capabilities = capabilities,
  rootPatterns = { "compile_commands.json", ".git/", ".hg/" },
  filetypes = { "c", "cc", "cpp", "c++", "objc", "objcpp", "h", "hpp", "cuda" },
}

require("lspconfig").cmake.setup {
  capabilities = capabilities,
}

-- Set lsp diagnostic signs
vim.api.nvim_command("sign define LspDiagnosticsSignError text=\\ ☠")
vim.api.nvim_command("sign define LspDiagnosticsSignWarning text=⚠")
vim.api.nvim_command("sign define LspDiagnosticsSignInformation text=ⓘ")
vim.api.nvim_command("sign define lspLspDiagnosticsSignHint text=⚐")

-- VimTeX
vim.g.vimtex_mappings_disable = {
  n = { '<leader>ls', '<leader>ll', '<leader>lv' },
}
vim.g.vimtex_quickfix_open_on_warning = false
vim.g.vimtex_quickfix_ignore_filters = {
  "Overfull",
  "Underfull",
  "float specifier",
}

vim.g.tex_flavour = 'luatex'
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'
-- vim.g.vimtex_compiler_latexmk_engines = {
--   ['_']                = '',
--   ['pdflatex']         = '-pdf',
--   ['dvipdfex']         = '-pdfdvi',
--   ['lualatex']         = '-lualatex',
--   ['xelatex']          = '-xelatex',
--   ['context (pdftex)'] = '-pdf -pdflatex=texexec',
--   ['context (luatex)'] = '-pdf -pdflatex=context',
--   ['context (xetex)']  = '-pdf -pdflatex=\'\'texexec --xtx\'\'',
-- }

vim.g.vimtex_compiler_latexmk = {
      ['executable'] = 'latexmk',
      ['callback'] = 1,
      ['hooks']  = {},
      ['options'] = {
    '-file-line-error',
    '-synctex=1',
    '-interaction=nonstopmode',
  },
}

return {
  print_response = function(err, method, result, client_id, bufnr, config)
    print("Config: " .. vim.inspect(config) .. " " ..
      "Method: " .. vim.inspect(method) .. " " ..
      "Result: " .. vim.inspect(result))
  end
}
