local M = {}

local B = require 'base'

-- common
local lspconfig = require 'lspconfig'
local nls = require 'null-ls'
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = require 'cmp_nvim_lsp'.default_capabilities(capabilities)

require 'mason'.setup {
  install_root_dir = B.getcreate_stddata_dirpath 'mason'.filename,
  pip = {
    upgrade_pip = true,
    install_args = { '-i', 'https://pypi.tuna.tsinghua.edu.cn/simple', '--trusted-host', 'mirrors.aliyun.com', },
  },
}

require 'mason-lspconfig'.setup {
  ensure_installed = {
    'clangd',
    'pyright',
    'lua_ls',
    -- 'marksman',
  },
  automatic_installation = true,
}

require 'mason-null-ls'.setup {
  ensure_installed = {
    'black', 'isort', -- python
    -- 'markdownlint',
    'clang_format',   -- clang_format
    -- 'prettier', 'prettierd',
    -- 'gitsigns',
    -- 'cspell',
    -- 'buf',
    -- 'markdownlint_cli2',
    -- 'markdown_toc',
    'trim_newlines',
    'trim_whitespace',
  },
  automatic_installation = true,
}

nls.setup {
  sources = {
    nls.builtins.formatting.clang_format.with { filetypes = { 'c', 'cpp', '*.h', }, },
    nls.builtins.formatting.black.with { extra_args = { '--fast', }, filetypes = { 'python', }, },
    nls.builtins.formatting.isort.with { extra_args = { '--profile', 'black', }, filetypes = { 'python', }, },
    -- nls.builtins.diagnostics.markdownlint.with { extra_args = { '-r', '~MD013', }, filetypes = { 'markdown', }, },
    -- nls.builtins.formatting.markdownlint.with { filetypes = { 'markdown', }, },
    -- nls.builtins.formatting.prettier.with { filetypes = { 'markdown', }, timeout = 10000, },
    -- nls.builtins.formatting.prettierd.with { filetypes = { 'markdown', }, },
    -- nls.builtins.code_actions.gitsigns.with {},
    -- nls.builtins.code_actions.cspell.with {},
    -- nls.builtins.diagnostics.buf.with {},
    -- nls.builtins.diagnostics.markdownlint_cli2.with {},
    -- nls.builtins.formatting.markdown_toc.with {},
    nls.builtins.formatting.trim_newlines.with {},
    nls.builtins.formatting.trim_whitespace.with {},
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

-- python
lspconfig.pyright.setup {
  capabilities = capabilities,
  root_dir = M.root_dir {
    '.git',
  },
}

-- -- markdown
-- lspconfig.marksman.setup {
--   capabilities = capabilities,
--   root_dir = M.root_dir {
--     '.git',
--   },
-- }

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

-- functions
function M.stop_all() vim.lsp.stop_client(vim.lsp.get_active_clients(), true) end

function M.rename() vim.fn.feedkeys(':IncRename ' .. vim.fn.expand '<cword>') end

function M.diagnostic_open_float() vim.diagnostic.open_float() end

function M.diagnostic_setloclist() vim.diagnostic.setloclist() end

function M.diagnostic_goto_prev() vim.diagnostic.goto_prev() end

function M.diagnostic_goto_next() vim.diagnostic.goto_next() end

function M.diagnostic_enable() vim.diagnostic.enable() end

function M.diagnostic_disable() vim.diagnostic.disable() end

function M.definition() vim.lsp.buf.definition() end

function M.declaration() vim.lsp.buf.declaration() end

function M.hover() vim.lsp.buf.hover() end

function M.implementation() vim.lsp.buf.implementation() end

function M.signature_help() vim.lsp.buf.signature_help() end

function M.references() vim.lsp.buf.references() end

function M.type_definition() vim.lsp.buf.type_definition() end

function M.code_action() vim.lsp.buf.code_action() end

function M.LspStart() vim.cmd 'LspStart' end

function M.LspRestart() vim.cmd 'LspRestart' end

function M.LspInfo() vim.cmd 'LspInfo' end

function M.feedkeys_LspStop() vim.fn.feedkeys ':LspStop ' end

function M.ClangdSwitchSourceHeader() vim.cmd 'ClangdSwitchSourceHeader' end

function M.retab_erase_bad_white_space()
  vim.cmd 'retab'
  pcall(vim.cmd, [[%s/\s\+$//]])
end

function M.format()
  require 'config.my.markdown'.align_table()
  vim.lsp.buf.format {
    async = true,
    filter = function(client)
      return client.name ~= 'clangd' -- clang-format nedd to check pyvenv.cfg
    end,
  }
end

function M.format_paragraph()
  local save_cursor = vim.fn.getpos '.'
  vim.cmd 'norm =ap'
  pcall(vim.fn.setpos, '.', save_cursor)
end

function M.format_input()
  local dirs = B.get_file_dirs_till_git()
  for _, dir in ipairs(dirs) do
    local _clang_format_path = require 'plenary.path':new(B.rep_slash_lower(dir)):joinpath '.clang-format'
    if _clang_format_path:exists() then
      B.cmd('e %s', _clang_format_path.filename)
      break
    end
  end
end

-- mappings
B.del_map({ 'n', 'v', }, '<leader>f')
B.del_map({ 'n', 'v', }, '<leader>fv')

require 'base'.whichkey_register({ 'n', 'v', }, '<leader>f', 'nvim.lsp')
require 'base'.whichkey_register({ 'n', 'v', }, '<leader>fv', 'nvim.lsp.more')

B.lazy_map {
  { '<leader>fn',     function() M.rename() end,                      mode = { 'n', 'v', }, desc = 'config.nvim.lsp: rename', },
  { '<leader>fC',     function() M.format_input() end,                mode = { 'n', 'v', }, desc = 'config.nvim.lsp: format_input', },
  { '<leader>fD',     function() M.feedkeys_LspStop() end,            mode = { 'n', 'v', }, desc = 'config.nvim.lsp: feedkeys_LspStop', },
  { '<leader>f<c-f>', function() M.LspInfo() end,                     mode = { 'n', 'v', }, desc = 'config.nvim.lsp: LspInfo', },
  { '<leader>f<c-r>', function() M.LspRestart() end,                  mode = { 'n', 'v', }, desc = 'config.nvim.lsp: LspRestart', },
  { '<leader>f<c-s>', function() M.LspStart() end,                    mode = { 'n', 'v', }, desc = 'config.nvim.lsp: LspStart', },
  { '<leader>f<c-w>', function() M.stop_all() end,                    mode = { 'n', 'v', }, desc = 'config.nvim.lsp: stop_all', },
  { '<leader>fc',     function() M.code_action() end,                 mode = { 'n', 'v', }, desc = 'config.nvim.lsp: code_action', },
  { '<leader>fi',     function() M.implementation() end,              mode = { 'n', 'v', }, desc = 'config.nvim.lsp: implementation', },
  { '<leader>fp',     function() M.format_paragraph() end,            mode = { 'n', 'v', }, desc = 'config.nvim.lsp: format_paragraph', },
  { '<leader>fs',     function() M.signature_help() end,              mode = { 'n', 'v', }, desc = 'config.nvim.lsp: signature_help', },
  { '<leader>fq',     function() M.diagnostic_enable() end,           mode = { 'n', 'v', }, desc = 'config.nvim.lsp: diagnostic_enable', },
  { '<leader>fvq',    function() M.diagnostic_disable() end,          mode = { 'n', 'v', }, desc = 'config.nvim.lsp: diagnostic_disable', },
  { '<leader>fve',    function() M.retab_erase_bad_white_space() end, mode = { 'n', 'v', }, desc = 'config.nvim.lsp: retab_erase_bad_white_space', },
  { '<leader>fvd',    function() M.type_definition() end,             mode = { 'n', 'v', }, desc = 'config.nvim.lsp: type_definition', },
  --
  { '[d',             function() M.diagnostic_goto_prev() end,        mode = { 'n', 'v', }, desc = 'config.nvim.lsp: diagnostic_goto_prev', },
  { '[f',             function() M.diagnostic_open_float() end,       mode = { 'n', 'v', }, desc = 'config.nvim.lsp: diagnostic_open_float', },
  { ']d',             function() M.diagnostic_goto_next() end,        mode = { 'n', 'v', }, desc = 'config.nvim.lsp: iagnostic_goto_next', },
  { ']f',             function() M.diagnostic_setloclist() end,       mode = { 'n', 'v', }, desc = 'config.nvim.lsp: diagnostic_setloclist', },
  --
  { '<leader>fo',     function() M.declaration() end,                 mode = { 'n', 'v', }, desc = 'config.nvim.lsp: declaration', },
  { '<C-F12>',        function() M.declaration() end,                 mode = { 'n', 'v', }, desc = 'config.nvim.lsp: declaration', },
  { '<leader>fw',     function() M.ClangdSwitchSourceHeader() end,    mode = { 'n', 'v', }, desc = 'config.nvim.lsp: ClangdSwitchSourceHeader', },
  { '<F11>',          function() M.ClangdSwitchSourceHeader() end,    mode = { 'n', 'v', }, desc = 'config.nvim.lsp: ClangdSwitchSourceHeader', },
  { '<leader>fd',     function() M.definition() end,                  mode = { 'n', 'v', }, desc = 'config.nvim.lsp: definition', },
  { '<F12>',          function() M.definition() end,                  mode = { 'n', 'v', }, desc = 'config.nvim.lsp: definition', },
  { '<leader>fe',     function() M.references() end,                  mode = { 'n', 'v', }, desc = 'config.nvim.lsp: references', },
  { '<S-F12>',        function() M.references() end,                  mode = { 'n', 'v', }, desc = 'config.nvim.lsp: references', },
  { '<leader>fh',     function() M.hover() end,                       mode = { 'n', 'v', }, desc = 'config.nvim.lsp: hover', },
  { '<A-F12>',        function() M.hover() end,                       mode = { 'n', 'v', }, desc = 'config.nvim.lsp: hover', },
}

return M
