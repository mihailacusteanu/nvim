-- ~/.config/nvim/lua/plugins/codecompanion.lua
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim", -- optional
  },
  event = "VeryLazy",
  config = function()
    require("codecompanion").setup({
      adapters = {
        http = {
          ollama = {
            name = "ollama",
            endpoint = "http://127.0.0.1:11434/api/chat",
            opts = {
              model = "qwen2.5-coder:7b", -- or llama3.1:8b
            },
          },
        },
      },

      strategies = {
        chat = { adapter = "ollama" },
        inline = { adapter = "ollama" },
      },
    })
  end,
}

