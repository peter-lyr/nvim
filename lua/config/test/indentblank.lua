local B = require 'base'

-- indentscope
B.aucmd('FileType', 'test.indentblank.FileType', {
  pattern = {
    'help',
    'NvimTree',
    'fugitive',
    'lazy',
    'mason',
    'notify',
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

B.aucmd('BufReadPre', 'test.indentblank.BufReadPre', {
  callback = function(ev)
    local max_filesize = 1000 * 1024
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
    if ok and stats and stats.size > max_filesize then
      vim.b.miniindentscope_disable = true
    end
  end,
})

require 'mini.indentscope'.setup {
  symbol = '│',
  options = { try_as_border = true, },
}

-- indentblank
require 'ibl'.setup {
  enabled = true,
  debounce = 200,
  viewport_buffer = {
    min = 30,
    max = 500,
  },
  indent = {
    -- char = '▎',
    char = '│',
    tab_char = nil,
    highlight = 'IblIndent',
    smart_indent_cap = true,
    priority = 1,
  },
  whitespace = {
    highlight = 'IblWhitespace',
    remove_blankline_trail = true,
  },
  scope = {
    enabled = true,
    char = nil,
    show_start = true,
    show_end = true,
    show_exact_scope = false,
    injected_languages = true,
    highlight = 'IblScope',
    priority = 1024,
    include = {
      node_type = {},
    },
    exclude = {
      language = {},
      node_type = {
        ['*'] = {
          'source_file',
          'program',
        },
        lua = {
          'chunk',
        },
        python = {
          'module',
        },
      },
    },
  },
  exclude = {
    filetypes = {
      --- my
      'qf',
      'lazy',
      'mason',
      'notify',
      'startuptime',
      ---
      'lspinfo',
      'packer',
      'checkhealth',
      'help',
      'man',
      'gitcommit',
      'TelescopePrompt',
      'TelescopeResults',
      '',
    },
    buftypes = {
      'terminal',
      'nofile',
      'quickfix',
      'prompt',
    },
  },
}
