local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(_, bufnr)
  local o = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, o)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, o)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, o)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, o)
  vim.keymap.set("n", "K",  vim.lsp.buf.hover, o)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, o)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, o)
  vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, o)
end

-- Ruff (formatter + linter + quickfixes)
lspconfig.ruff.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    on_attach(client, bufnr)
  end,
  init_options = {
    settings = {
      args = {}, -- e.g. { "--line-length=100" }
    },
  },
})

-- Pyright (types, defs, hover, rename)
lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic", -- "off" | "basic" | "strict"
        autoImportCompletions = true,
      },
    },
  },
})
