require 'oil'.setup {
  keymaps = {
    ['<c-;>'] = 'actions.select',
    ['<c-2>'] = 'actions.select',
    ['<c-1>'] = 'actions.parent',
    ['<c-q>'] = 'actions.close',
    ['<c-3>'] = 'actions.close',
    ['gx'] = {
      callback = function()
        local entry = require 'oil'.get_cursor_entry()
        local dir = require 'oil'.get_current_dir()
        if not entry or not dir then return end
        require 'base'.system_run('start silent', 'start %s', dir .. entry.name)
      end,
      desc = 'test.oil: start',
      mode = { 'n', 'v', },
    },
    ['<c-tab>'] = {
      callback = function()
        local entry = require 'oil'.get_cursor_entry()
        local dir = require 'oil'.get_current_dir()
        if not entry or not dir then return end
        vim.cmd 'NvimTreeOpen'
        require 'base'.cmd('cd %s', dir .. entry.name)
      end,
      desc = 'test.oil: nvimtree',
      mode = { 'n', 'v', },
    },
  },
  columns = {
    'icon',
    'permissions',
    'size',
    'mtime',
  },
}
