local plugins = {
      {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "pyright",
                "debugpy",
                "mypy",
                "ruff",
                "black",
                "codelldb",
                "clangd",
                "clang-format",
                "texlab",
                "cmake-language-server",
                "cmakelang",
                "omnisharp",
                "lua-language-server",
                "stylua",
            },
        },
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter"
        },
        config = function ()
            require('neotest').setup {
                adapters = {
                    require('rustaceanvim.neotest')
                },
            }
        end
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false, -- This plugin is already lazy
        config = function ()
            vim.g.rustaceanvim = {
                -- Plugin configuration
                tools = {
                    test_executor = 'background'
                },
                -- LSP configuration
                server = {
                    on_attach = function (client, bufnr)
                        -- on_attach(client, bufnr)
                        if vim.lsp.inlay_hint then
                            vim.lsp.inlay_hint.enable(true, { 0 })
                        end
                        vim.diagnostic.config({
                            underline = true,
                            signs = true,
                            virtual_text = false,
                            float = {
                                show_header = true,
                                source = 'always',
                                border = 'rounded',
                                focusable = false,
                            },
                            update_in_insert = true, -- default to false
                            severity_sort = true, -- default to false
                        })
                        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                            vim.lsp.diagnostic.on_publish_diagnostics, {
                                virtual_text = false,
                                underline = true,
                                signs = true,
                            }
                        )
                        vim.api.nvim_create_autocmd('CursorHold', { command = 'lua vim.diagnostic.open_float()'})
                        -- vim.api.nvim_create_autocmd('CursorHold', { command = 'silent! lua vim.lsp.buf.signature_help()'})
                    end,
                    default_settings = {
                        -- rust-analyzer language server configuration
                        ['rust-analyzer'] = {
                            checkOnSave = true,
                            check = {
                                enable = true,
                                command = "clippy",
                            },
                        },
                    },---@param project_root string Path to the project root
                    settings = function(project_root)
                        local ra = require('rustaceanvim.config.server')
                        return ra.load_rust_analyzer_settings(project_root, {
                            settings_file_pattern = 'rust-analyzer.json'
                        })
                    end,
                },
                -- DAP configuration
                dap = {
                },
            }
            -- vim.cmd.RustLsp('expandMacro')
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
            dependencies = {
                "williamboman/mason.nvim",
                "mfussenegger/nvim-dap",
            },
            opts = {
                handlers = {},
                ensure_installed = {}
            },
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("plugins.configs.lspconfig")
            require("custom.configs.lspconfig")
        end
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = "VeryLazy",
        ft = {"python"},
        opts = function ()
            return require("custom.configs.null-ls")
        end,
    },
    {
        "nmac427/guess-indent.nvim",
        config = function ()
            require('guess-indent').setup()
        end,
        lazy = false,
    },
    {
        "mfussenegger/nvim-dap",
        config = function(_, opts)
            require("core.utils").load_mappings("dap")
        end,
        dependencies = {
            "nvim-neotest/nvim-nio",
        }
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function(_, opts)
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)
            require("core.utils").load_mappings("dap_python")
        end,
    },
    {
        "AckslD/swenv.nvim",
        config = function (_, opts)
            require('swenv').setup({
            -- Should return a list of tables with a `name` and a `path` entry each.
            -- Gets the argument `venvs_path` set below.
            -- By default just lists the entries in `venvs_path`.
            get_venvs = function(venvs_path)
                return require('swenv.api').get_venvs(venvs_path)
            end,
             -- Path passed to `get_venvs`.
            venvs_path = vim.fn.expand('~/venvs'),
            -- Something to do after setting an environment, for example call vim.cmd.LspRestart
            post_set_venv = vim.cmd.LspRestart,
            })
        end,
        ft = "python",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim",
        }

    },
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            require("custom.configs.nvim-dap-ui")
        end,
    },
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },
    {
        "kdheepak/lazygit.nvim",
        event = "VeryLazy",
        -- optional for floating window border
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "rust-lang/rust.vim",
        ft = "rust",
        init = function ()
            vim.g.rustfmt_autosave = 1
        end
    },
    {
        "folke/trouble.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        opts =function()
            require("custom.configs.trouble")
        end,
        cmd = "Trouble",
         keys = {
            {
              "<leader>tt",
              "<cmd>Trouble diagnostics toggle<cr>",
              desc = "Diagnostics (Trouble)",
            },
            {
              "<leader>ti",
              "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
              desc = "Buffer Diagnostics (Trouble)",
            },
            {
              "<leader>ts",
              "<cmd>Trouble symbols toggle focus=false<cr>",
              desc = "Symbols (Trouble)",
            },
            {
              "<leader>tr",
              "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
              desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
              "<leader>tl",
              "<cmd>Trouble loclist toggle<cr>",
              desc = "Location List (Trouble)",
            },
            {
              "<leader>tq",
              "<cmd>Trouble qflist toggle<cr>",
              desc = "Quickfix List (Trouble)",
            },
        },
    }
}
return plugins
