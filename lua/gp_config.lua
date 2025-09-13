-- ~/.config/nvim/lua/gp_config.lua
-- extra shortcuts for gp.nvim

-- fail-safe: skip if plugin isn't loaded
local ok = pcall(require, "gp")
if not ok then return end

local map = vim.keymap.set
map({ "n", "v" }, "<leader>gc", "<cmd>GpChatToggle<CR>", { desc = "gp.nvim: Toggle Chat" })
map({ "n", "v" }, "<leader>gn", "<cmd>GpChatNew<CR>",    { desc = "gp.nvim: New Chat" })
map({ "n", "v" }, "<leader>gr", "<cmd>GpRewrite<CR>",    { desc = "gp.nvim: Rewrite" })
map({ "n", "v" }, "<leader>gi", "<cmd>GpInline<CR>",     { desc = "gp.nvim: Inline edit" })
map({ "n", "v" }, "<leader>ga", "<cmd>GpAppend<CR>",     { desc = "gp.nvim: Append below" })
map({ "n", "v" }, "<leader>gp", "<cmd>GpPopup<CR>",      { desc = "gp.nvim: Popup response" })

