return {
  setup = function()
    require('neogit').setup {
      disable_signs = true,
      disable_hint = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
      -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
      auto_refresh = true,
      disable_builtin_notifications = false,
      use_magit_keybindings = false,
      commit_popup = {
        kind = "split",
      },
      -- Change the default way of opening neogit
      kind = "tab",
      -- customize displayed signs
      signs = {
        -- { CLOSED, OPENED }
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { "", "" },
      },
      integrations = {
        diffview = false
      },
      -- Setting any section to `false` will make the section not render at all
      sections = {
        untracked = { folded = false, hidden = false },
        unstaged = { folded = false, hidden = false },
        staged = { folded = false, hidden = false },
        stashes = { folded = true, hidden = false },
        unpulled = { folded = true, hidden = false },
        unmerged = { folded = false, hidden = false },
        recent = { folded = true, hidden = false },
      },
    }

    -- Neogit Highlighting
    vim.cmd("hi NeogitDiffAdd guibg='#78997a' guifg='#f4f0ed'")
    vim.cmd("hi NeogitDiffDelete guibg='#7d2a2f' guifg='#f4f0ed'")
    vim.cmd("hi NeogitDiffContextHighlight guibg='#4d453e'")

    vim.cmd("hi NeogitHunkHeaderHighlight guibg='#697893'")
  end
}
