vim.opt.mouse = "a"
vim.keymap.set("i","<S-Insert>", "<C-R>*")

-- vim.opt.pastetoggle = "<F3>"

-- vim.opt.cindent = true
-- vim.opt.autoindent = true
-- vim.opt.smartindent = true
-- vim.opt.copyindent = true
-- vim.opt.fsync = true

vim.opt.relativenumber = true

vim.diagnostic.config({
    underline = true,
    signs = true,
    virtual_text = false,
    float = {
        show_header = true,
        source = 'if_many',
        border = 'rounded',
        focusable = false,
    },
    update_in_insert = false, -- default to false
    severity_sort = false, -- default to false
})
-- Use this if you want it to automatically show all diagnostics on the
-- current line in a floating window. Personally, I find this a bit
-- distracting and prefer to manually trigger it (see below). The
-- CursorHold event happens when after `updatetime` milliseconds. The
-- default is 4000 which is much too long
-- vim.cmd('autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()')
-- vim.o.updatetime = 300
--
-- -- Show all diagnostics on current line in floating window
-- vim.api.nvim_set_keymap(
--   'n', '<Leader>d', ':lua vim.diagnostic.open_float()<CR>', 
--   { noremap = true, silent = true }
-- )
-- -- Go to next diagnostic (if there are multiple on the same line, only shows
-- -- one at a time in the floating window)
-- vim.api.nvim_set_keymap(
--   'n', '<Leader>n', ':lua vim.diagnostic.goto_next()<CR>',
--   { noremap = true, silent = true }
-- )
-- -- Go to prev diagnostic (if there are multiple on the same line, only shows
-- -- one at a time in the floating window)
-- vim.api.nvim_set_keymap(
--   'n', '<Leader>p', ':lua vim.diagnostic.goto_prev()<CR>',
--   { noremap = true, silent = true }
-- )
