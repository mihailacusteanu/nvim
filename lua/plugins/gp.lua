-- ~/.config/nvim/lua/plugins/gp.lua
return {
  {
    "robitx/gp.nvim",
    event = "VeryLazy",
    config = function()
      require("gp").setup({
        providers = {
          openai = { disable = true },
          ollama = {
            disable = false,
            endpoint = "http://localhost:11434/api/chat",
            secret = "dummy",
          },
        },
        default_chat_agent = "OllamaChat",
        default_command_agent = "OllamaChat",
        agents = {
          {
            name = "OllamaChat",
            provider = "ollama",
            chat = true,
            command = true,
            model = { model = "llama3.1:8b", temperature = 0.3, top_p = 0.9 },
            system_prompt = "You are a helpful coding assistant inside Neovim.",
          },
          {
            name = "OllamaCoder",
            provider = "ollama",
            chat = true,
            command = true,
            model = { model = "qwen2.5-coder:7b", temperature = 0.2, top_p = 0.95 },
            system_prompt = "You write precise, minimal code with brief explanations.",
          },
        },
      })

      -- always mention file name:
      require("gp_config")
    end,
  },
}

