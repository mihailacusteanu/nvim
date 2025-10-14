vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Add asdf Node.js bin to PATH for formatters
vim.env.PATH = vim.env.PATH .. ":/Users/mihai/.asdf/installs/nodejs/24.7.0/bin"

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
        ensure_installed = { "elixirls", "pyright", "ruff", "ts_ls", "eslint", "tailwindcss", "emmet_ls", "gopls" }, -- ⬅️ emmet_ls kept
      })
    end
  },

  -- LSP
  { "neovim/nvim-lspconfig",
    config = function()
      require("elixir_ls")   -- ~/.config/nvim/lua/elixir_ls.lua
      require("python_ls")   -- ~/.config/nvim/lua/python_ls.lua
      require("javascript_ls")
      require("tailwind_ls") -- ~/.config/nvim/lua/tailwind_ls.lua
      require("go_ls")

      -- Emmet via LSP (for .space-y-6 → <div class="space-y-6"></div>)
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig.emmet_ls.setup({
        capabilities = capabilities,
        filetypes = {
          "html", "css", "sass", "scss", "less",
          "javascriptreact", "typescriptreact",
          "javascript", "typescript",
        },
      })
    end
  },

  -- Treesitter (syntax/highlight/indent)
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "elixir", "eex", "heex", "lua", "vim", "python",
	"javascript", "typescript", "tsx", "json", "css", "html", "go"
			},
        highlight = { enable = true },
        indent    = { enable = true },
      })
    end
  },

  -- ⬅️ NEW: Auto-close/rename HTML & JSX/TSX tags
  { "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end
  },

-- Completion
{ "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",              -- snippet engine
    "rafamadriz/friendly-snippets",  -- pre-made snippets (React, etc.)
    "saadparwaiz1/cmp_luasnip",      -- connect LuaSnip to nvim-cmp
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Load VSCode-style snippets (friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"]      = cmp.mapping.confirm({ select = true }),
        ["<Tab>"]     = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"]   = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "luasnip" }, -- enable snippets as a source
      }),
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

	{ "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
	go = { "goimports", "gofmt" },  
      },
      -- Save-time fallback (still lets you use LSP formatting if no formatter is available)
      format_on_save = function(_)
        return { lsp_fallback = true, timeout_ms = 500 }
      end,
    })

    vim.keymap.set("n", "<leader>f", function()
      require("conform").format({ async = true })
    end, { desc = "Format buffer" })
  end
},
-- Copilot disabled to avoid subscription warnings
-- {
--   "zbirenbaum/copilot.lua",
--   event = "InsertEnter",
--   config = function()
--     require("copilot").setup({
--       panel = { enabled = false }, -- no side panel
--       suggestion = {
--         enabled = true,
--         auto_trigger = false,       -- 🔒 DO NOT auto-popup
--         debounce = 75,
--         keymap = {
--           accept = "<C-j>",
--           accept_word = "<M-w>",
--           accept_line = "<M-l>",
--           next = "<C-]>",
--           prev = "<C-k>",
--           dismiss = "<C-/>",
--         },
--       },
--     })
--   end,
-- },
})

-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
--   callback = function(data)
--     local directory = vim.fn.isdirectory(data.file) == 1
--     if directory then
--       vim.cmd.cd(data.file)
--       require("nvim-tree.api").tree.open()
--     else
--       require("nvim-tree.api").tree.open()
--     end
--   end
-- })

-- 🔹 Custom command: ReplaceAll (search & replace across project)
vim.api.nvim_create_user_command("ReplaceAll", function(opts)
  local old = opts.fargs[1]
  local new = opts.fargs[2]

  if not old or not new then
    print("Usage: :ReplaceAll <old> <new>")
    return
  end

  vim.cmd("vimgrep /" .. old .. "/ **/*.ex **/*.exs")
  vim.cmd("cfdo %s/" .. old .. "/" .. new .. "/gc | update")
end, { nargs = "+" })


-- Copy diagnostic under cursor to clipboard
vim.keymap.set("n", "<leader>ce", function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
  if diagnostics[1] then
    vim.fn.setreg("+", diagnostics[1].message) -- copy to system clipboard
    print("Copied diagnostic: " .. diagnostics[1].message)
  else
    print("No diagnostic on this line")
  end
end, { desc = "Copy diagnostic message" })

