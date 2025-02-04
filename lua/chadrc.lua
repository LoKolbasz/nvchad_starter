---@type ChadrcConfig
local M = {}

M.base46 = { theme = "catppuccin" }
-- M.plugins = "custom.plugins"
require "configs.vim_config"
-- M.mappings = require("custom.mappings")
-- require("custom.lsp")
-- requie("custom.configs.nvim_tree")
--require'nvim-treesitter.configs'.setup {
--  indent = {
--    enable = true
--  }
--}
return M
