return {
  -- sanity check plugins so you can see Lazy doing work
  { "folke/which-key.nvim", opts = {} },
  { "nvim-lua/plenary.nvim" },

  -- core LSP plumbing
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },

  -- Elixir tooling (ElixirLS)
  { "elixir-tools/elixir-tools.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- formatter
  { "stevearc/conform.nvim" },
}
