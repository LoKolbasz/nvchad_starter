local M = {}

M.dap = {
    plugin = true,
    n = {
        ["<leader>db"] = {"<cmd>DapToggleBreakpoint <CR>", "Add breakpoint at line"},
        ["<leader>dr"] = {"<cmd>DapContinue <CR>", "Start or continue the debugger"},
        ["<leader>dg"] = {"<cmd> :lua os.execute(\"cd build && cmake -S ../ -B ./ -DCMAKE_BUILD_TYPE=debug -DCMAKE_EXPORT_COMPILE_COMMANDS=1\") <CR>", "Generates a compile_commands.json for ale supported tools"}
    }
}

M.dap_python = {
    plugin = true,
    n = {
        ["<leader>dpr"] = {
            function()
                require("dap-python").test_method()
            end
        }
    }
}
M.general = {
    n = {
        ["<C-h>"] = {"<cmd> TmuxNavigateLeft<CR>", "window left"},
        ["<C-l>"] = {"<cmd> TmuxNavigateRight<CR>", "window right"},
        ["<C-j>"] = {"<cmd> TmuxNavigateDown<CR>", "window down"},
        ["<C-k>"] = {"<cmd> TmuxNavigateUp<CR>", "window up"},
        ["<leader>gg"] = {"<cmd>LazyGit <CR>", "Lazygit"},
        -- ["<leader>tt"] =  {function () require("trouble").toggle() end, "Toggle LSP diagnostics"},
        -- ["<leader>tw"] =  {function () require("trouble").toggle("workspace_diagnostics") end, "LSP worksace diagnostics"},
        -- ["<leader>td"] =  {function () require("trouble").toggle("diagnostics_buffer") end, "LSP document diagnostics"},
        -- ["<leader>tq"] =  {function () require("trouble").toggle("quickfix") end, "LSP quickfix items"},
        -- ["<leader>tl"] =  {function () require("trouble").toggle("loclist") end, "LSP location list items"},
        -- ["<leader>gR"] =  {function () require("trouble").toggle("lsp_references") end, "LSP references of word under cursor"},
        ["<leader>pvs"] = {function () require("swenv.api").get_current_venv() end, "Show the current venv"},
        ["<leader>pvp"] = {function () require("swenv.api").pick_venv() end, "Pick a venv"},
        ["<leader>trf"] = {function () require("neotest").run.run(vim.fn.expand("%")) end, "Run tests in file"},
        ["<leader>trn"] = {function () require("neotest").run.run() end, "Run nearest test"},
        ["<leader>ls"] = {function () vim.lsp.buf.signature_help() end, "LSP signature help"},
    ["<leader>lf"] = {function() vim.diagnostic.open_float { border = "rounded" } end, "Floating diagnostic"},
    ["<leader>ra"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "LSP rename",
    },

    ["<leader>ca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },
    },
}
return M
