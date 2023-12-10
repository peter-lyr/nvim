local M = {}

local B = require 'base'

-- common
local lspconfig = require 'lspconfig'
local nls = require 'null-ls'
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = require 'cmp_nvim_lsp'.default_capabilities(capabilities)

require 'mason'.setup { install_root_dir = B.getcreate_stddata_dirpath 'mason'.filename, }

require 'mason-null-ls'.setup {
  ensure_installed = {
    'clang_format',
  },
  automatic_installation = true,
}

require 'mason-lspconfig'.setup {
  ensure_installed = {
    'clangd',
    'pyright',
    'lua_ls',
  },
  automatic_installation = true,
}

nls.setup {
  sources = {
    nls.builtins.formatting.clang_format.with { filetypes = { 'c', 'cpp', '*.h', }, },
  },
}

B.aucmd('LspAttach', 'LspAttach', {
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    B.lazy_map { { 'K', vim.lsp.buf.definition, mode = { 'n', 'v', }, buffer = ev.buf, desc = 'vim.lsp.buf.definition', }, }
  end,
})

function M.root_dir(root_files)
  return function(fname)
    local util = require 'lspconfig.util'
    return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
  end
end

-- clangd
lspconfig.clangd.setup {
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = 'utf-16',
  },
  root_dir = M.root_dir {
    'build',
    '.cache',
    'compile_commands.json',
    'CMakeLists.txt',
    '.git',
  },
}

-- lua
require 'neodev'.setup()

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  root_dir = M.root_dir {
    '.git',
  },
  single_file_support = true,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', },
        disable = {
          'incomplete-signature-doc',
          'undefined-global',
        },
        groupSeverity = {
          strong = 'Warning',
          strict = 'Warning',
        },
      },
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        library = {},
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
      completion = {
        workspaceWord = true,
        callSnippet = 'Both',
      },
      misc = {
        parameters = {
          '--log-level=trace',
        },
      },
      format = {
        enable = true,
        defaultConfig = {
          max_line_length          = '200',
          indent_size              = '2',
          call_arg_parentheses     = 'remove',
          trailing_table_separator = 'always',
          quote_style              = 'single',
        },
      },
    },
  },
}

-- others
require 'inc_rename'.setup()

for name, icon in pairs(require 'lazyvim.config'.icons.diagnostics) do
  name = 'DiagnosticSign' .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '', })
end

vim.diagnostic.config {
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 0,
    source = 'if_many',
    prefix = '●',
  },
  severity_sort = true,
}

return M
