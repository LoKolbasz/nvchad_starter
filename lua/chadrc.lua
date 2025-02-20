require "configs.vim_config"
require "commands.ollama"

---@type ChadrcConfig
local M = {}

M.base46 = { theme = "catppuccin" }
-- M.plugins = "custom.plugins"
-- M.mappings = require("custom.mappings")
-- require("custom.lsp")
-- requie("custom.configs.nvim_tree")
--require'nvim-treesitter.configs'.setup {
--  indent = {
--    enable = true
--  }
--}
return M
