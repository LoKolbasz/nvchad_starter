-- NvChad defaults
require "nvchad.mappings"

local builtin_map = vim.keymap.set

builtin_map("n", ";", ":", { desc = "CMD enter command mode" })
builtin_map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
local map = require("which-key").add

map {
  { "<leader> d", group = "Debug" },
  {
    mode = { "n" },
    { "<leader>db", "<cmd>DapToggleBreakpoint <CR>", desc = "Add breakpoint at line" },
    { "<leader>dr", "<cmd>DapContinue <CR>", desc = "Start or continue the debugger" },
    {
      "<leader>dg",
      '<cmd> :lua os.execute("cd build && cmake -S ../ -B ./ -DCMAKE_BUILD_TYPE=debug -DCMAKE_EXPORT_COMPILE_COMMANDS=1") <CR>',
      desc = "Generates a compile_commands.json for ale supported tools",
    },
  },
}

map {
  {
    mode = { "n" },
    {
      "<leader>dpr",
      function()
        require("dap-python").test_method()
      end,
    },
  },
}
map {
  {
    mode = { "n" },
    {
      { "<C-h>", "<cmd> TmuxNavigateLeft<CR>", desc = "window left" },
      { "<C-l>", "<cmd> TmuxNavigateRight<CR>", desc = "window right" },
      { "<C-j>", "<cmd> TmuxNavigateDown<CR>", desc = "window down" },
      { "<C-k>", "<cmd> TmuxNavigateUp<CR>", desc = "window up" },
      { "<leader>gg", "<cmd>LazyGit <CR>", desc = "Lazygit" },
      -- {"<leader>tt", function () require("trouble").toggle() end, desc = "Toggle LSP diagnostics"},
      -- {"<leader>tw", function () require("trouble").toggle("workspace_diagnostics") end, desc = "LSP worksace diagnostics"},
      -- {"<leader>td", function () require("trouble").toggle("diagnostics_buffer") end, desc = "LSP document diagnostics"},
      -- {"<leader>tq", function () require("trouble").toggle("quickfix") end, desc = "LSP quickfix items"},
      -- {"<leader>tl", function () require("trouble").toggle("loclist") end, desc = "LSP location list items"},
      -- {"<leader>gR", function () require("trouble").toggle("lsp_references") end, desc = "LSP references of word under cursor"},
      {
        "<leader>pvs",
        function()
          require("swenv.api").get_current_venv()
        end,
        desc = "Show the current venv",
      },
      {
        "<leader>pvp",
        function()
          require("swenv.api").pick_venv()
        end,
        desc = "Pick a venv",
      },
      {
        "<leader>trf",
        function()
          require("neotest").run.run(vim.fn.expand "%")
        end,
        desc = "Run tests in file",
      },
      {
        "<leader>trn",
        function()
          require("neotest").run.run()
        end,
        desc = "Run nearest test",
      },
      {
        "<leader>ls",
        function()
          vim.lsp.buf.signature_help()
        end,
        desc = "LSP signature help",
      },
      {
        "<leader>lf",
        function()
          vim.diagnostic.open_float { border = "rounded" }
        end,
        desc = "Floating diagnostic",
      },
      {
        "<leader>ca",
        function()
          vim.lsp.buf.code_action()
        end,
        desc = "LSP code action",
      },
    },
  },
}
