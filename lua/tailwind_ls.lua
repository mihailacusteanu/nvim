local lspconfig = require("lspconfig")

lspconfig.tailwindcss.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  filetypes = { "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  root_dir = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.ts", "postcss.config.js", "package.json", ".git"),
})
