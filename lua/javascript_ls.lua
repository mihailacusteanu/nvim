local lspconfig = require("lspconfig")

lspconfig.ts_ls.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
})

lspconfig.eslint.setup({
  root_dir = lspconfig.util.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.json"),
})

