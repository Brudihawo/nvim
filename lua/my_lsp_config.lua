local coq = require('coq')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true;
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--   vim.lsp.diagnostic.on_publish_diagnostics,
--   {
--     virtual_text = true;
--     underline = true;
--   }
-- )


require("lspconfig").pylsp.setup {
  coq.lsp_ensure_capabilities {
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
}

require("lspconfig").rust_analyzer.setup {
  coq.lsp_ensure_capabilities {
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
}

require("lspconfig").sumneko_lua.setup {
  coq.lsp_ensure_capabilities {
    cmd = { "lua-language-server" },
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { { 'vim' } },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }
}

require("lspconfig").texlab.setup {
  coq.lsp_ensure_capabilities {
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
        diagnosticsDelay = 100,
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
}


-- require("lspconfig").ccls.setup{
--   capabilities = coq.lsp_ensure_capabilities{
--     capabilities = capabilities,
--   },
--   init_options = {
--     index = { threads = 0; },
--     cache = { directory = "/tmp/ccls"; },
--     clang = { extraArgs = { "-Wmaybe-uninitialized", "-Wunused-variable", "-Wunknown-pragmas" } },
--   },
--   rootPatterns = { ".ccls", "compile_commands.json", ".git/", ".hg/" },
--   filetypes = { "c", "cc", "cpp", "c++", "objc", "objcpp", "h", "hpp" },
-- }

require("lspconfig").clangd.setup {
  capabilities = coq.lsp_ensure_capabilities {
    capabilities = capabilities,
  },
  rootPatterns = { "compile_commands.json", ".git/", ".hg/" },
  filetypes = { "c", "cc", "cpp", "c++", "objc", "objcpp", "h", "hpp" },
}

require("lspconfig").cmake.setup {
  coq.lsp_ensure_capabilities { capabilities = capabilities, }
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

-- VimTeX
vim.g.vimtex_mappings_disable = {
  n = { '<leader>ls', '<leader>ll', '<leader>lv' },
}
vim.g.vimtex_quickfix_open_on_warning = false
vim.g.vimtex_fold_enabled = true
vim.g.vimtex_syntax_conceal = {
  accents = true,
  ligatures = true,
  cites = true,
  fancy = true,
  greek = true,
  math_bounds = true,
  math_delimiters = true,
  math_fracs = true,
  math_super_sub = true,
  math_symbols = true,
  sections = true,
  styles = true,
}
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
  ['callback']   = 1,
  ['hooks']      = {},
  ['options']    = {
    '-file-line-error',
    '-synctex=1',
    '-interaction=nonstopmode',
  },
}

require("lspconfig").ltex.setup {}

require('symbols-outline').setup({
  symbol_blacklist = {
    'Property',
    'Field',
    'Variable',
    'Constant',
    'String',
    'Number',
    'Boolean',
    'Object',
    'Key',
    'Null',
    'EnumMember',
    'Event',
    'Operator',
    'TypeParameter',
    'Component',
    'Fragment',
  },
})

return {
  print_response = function(err, method, result, client_id, bufnr, config)
    print("Config: " .. vim.inspect(config) .. " " ..
      "Method: " .. vim.inspect(method) .. " " ..
      "Result: " .. vim.inspect(result))
  end
}
