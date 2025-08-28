-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Diagnostics popup
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics" })


-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Mason (manages LSP binaries)
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim", config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "elixirls", "pyright", "ruff" }, -- elixir + python
      })
    end
  },

  -- LSP
  { "neovim/nvim-lspconfig",
    config = function()
      require("elixir_ls")   -- ~/.config/nvim/lua/elixir_ls.lua
      require("python_ls")   -- ~/.config/nvim/lua/python_ls.lua
    end
  },

  -- Treesitter (syntax/highlight/indent)
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "elixir", "eex", "heex", "lua", "vim", "python" },
        highlight = { enable = true },
        indent    = { enable = true },
      })
    end
  },

  -- Completion
  { "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
        }),
        snippet = {
          expand = function(args) vim.snippet.expand(args.body) end,
        },
      })
    end
  },

  -- Colorscheme (Catppuccin)
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end
  },

  -- File Explorer: nvim-tree
  { "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- recommended by nvim-tree
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.opt.termguicolors = true

      require("nvim-tree").setup({
        git = {
          enable = true,
          ignore = false,
          timeout = 400,
        },
        view = { width = 30 },
        actions = { open_file = { quit_on_open = false } },
      })

      vim.keymap.set("n", "<C-n>", function()
        require("nvim-tree.api").tree.toggle()
      end, { noremap = true, silent = true, desc = "Toggle file tree" })
    end
  },

  -- Git signs
  { "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
      })

      local gs = package.loaded.gitsigns
      if gs then
        vim.keymap.set("n", "]c", gs.next_hunk, { desc = "Next git hunk" })
        vim.keymap.set("n", "[c", gs.prev_hunk, { desc = "Prev git hunk" })
        vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
        vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
        vim.keymap.set("n", "<leader>hb", gs.blame_line, { desc = "Blame line" })
        vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
      end
    end
  },
	{ "nvim-telescope/telescope.nvim", tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "Find buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags,  { desc = "Help tags" })
  end
},
	{ "kdheepak/lazygit.nvim", dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Open LazyGit" })
  end
},
{
  "nomnivore/ollama.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("ollama").setup({
      model = "deepseek-coder:6.7b", -- default model
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>oo", function()
      require("ollama").prompt()
    end, { desc = "Open Ollama prompt" })

    vim.keymap.set("v", "<leader>oo", function()
      require("ollama").prompt()
    end, { desc = "Send selection to Ollama" })
  end,
},
-- Autopairs (auto-close brackets, quotes, etc.)
{ "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({})
  end
},

})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function(data)
    local directory = vim.fn.isdirectory(data.file) == 1
    if directory then
      vim.cmd.cd(data.file)
      require("nvim-tree.api").tree.open()
    else
      require("nvim-tree.api").tree.open()
    end
  end
})
