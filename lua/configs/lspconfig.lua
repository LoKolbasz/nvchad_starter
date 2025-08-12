-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
--
-- local config = require("plugins.configs.lspconfig")

local on_attach = nvlsp.on_attach
local capabilities = nvlsp.capabilities
local util = require "lspconfig/util"

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "python" },
}

-- lspconfig.rust_analyzer.setup({
--     on_attach = function (client, bufnr)
--         on_attach(client, bufnr)
--         if vim.lsp.inlay_hint then
--             vim.lsp.inlay_hint.enable(true, { 0 })
--         end
--     end,
--     capabilities = capabilities,
--     filetypes = {"rust"},
--     root_dir = util.root_pattern("Cargo.toml"),
--     settings = {
--         ["rust-analyzer"] = {
-- 			checkOnSave = true,
-- 			check = {
-- 				enable = true,
-- 				command = "clippy",
-- 				features = "all",
-- 			},
-- 		},
--     }
-- })

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signitureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  filetypes = { "cpp", "c", "cuda" },
}

lspconfig.texlab.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "tex" },
}

lspconfig.cmake.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "cmake" },
}

lspconfig.fish_lsp.setup {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  filetypes = { "fish" },
}

local os = require "os"
local omnisharp_server_loc = os.getenv "OMNISHARP_LANGUAGE_SERVER"
local pid = vim.fn.getpid()
lspconfig.omnisharp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(pid) },
  filetypes = { "cs" },
}

lspconfig.ruff.setup {
  init_options = {
    settings = {
      configurationPreference = "filesystemFirst",
      lint = {
        preview = true,
        enable = true,
      },
      format = {
        preview = true,
        enable = true,
      }
    }
  },
  on_attach = function(args)
    on_attach()
    local client = vim.lsp.get_client_by_id(args.client_id)
    if client == nil then
      return
    end
    if client.name == "ruff" then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
    -- desc = 'LSP: Disable hover capability from Ruff',
  end,
  capabilities = capabilities,
  filetypes = { "py", "python" },
}
