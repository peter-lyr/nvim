local M = {}

local B = require 'base'

require 'oil'.setup {
  keymaps = {
    ['<c-;>'] = 'actions.select',
    ['<c-2>'] = 'actions.select',
    ['<c-1>'] = 'actions.parent',
    ['<c-q>'] = 'actions.close',
    ['<c-3>'] = 'actions.close',
    ['<c-x>'] = {
      callback = function()
        local entry = require 'oil'.get_cursor_entry()
        local dir = require 'oil'.get_current_dir()
        if not entry or not dir then return end
        require 'base'.system_run('start silent', 'start %s', dir .. entry.name)
      end,
      desc = 'test.oil: start',
      mode = { 'n', 'v', },
      nowait = true,
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
      nowait = true,
    },
    ['<c-a>'] = {
      callback = function()
        local dir = require 'oil'.get_current_dir()
        if not dir then return end
        B.ui_sel({
          'live_grep cwd=',
          'find_files cwd=',
          'grep_string cwd=',
        }, 'Telescope', function(cwd)
          if cwd then
            B.cmd('Telescope %s%s', cwd, B.rep_backslash(dir))
          end
        end)
      end,
      desc = 'test.oil: telescope all',
      mode = { 'n', 'v', },
      nowait = true,
    },
    ['<c-`>'] = {
      callback = function()
        local dir = require 'oil'.get_current_dir()
        if not dir then return end
        B.cmd('Telescope find_files cwd=%s', B.rep_backslash(dir))
      end,
      desc = 'test.oil: telescope find_files',
      mode = { 'n', 'v', },
      nowait = true,
    },
    ['<c-w>'] = {
      callback = function()
        local dir = require 'oil'.get_current_dir()
        if not dir then return end
        B.cmd('Telescope live_grep cwd=%s', B.rep_backslash(dir))
      end,
      desc = 'test.oil: telescope live_grep',
      mode = { 'n', 'v', },
      nowait = true,
    },
  },
  columns = {
    'icon',
    'permissions',
    'size',
    'mtime',
  },
}

function M.last_dir()
  if B.is(M._last_dir) then
    B.print('Oil %s', vim.inspect(M._last_dir))
    B.cmd('Oil %s', M._last_dir)
  end
end

B.aucmd({ 'CursorHold', 'CursorHoldI', }, 'test.oil.CursorHold', {
  callback = function(ev)
    if B.is_buf_fts('oil', ev.buf) then
      local dir = require 'oil'.get_current_dir()
      if not dir then return end
      M._last_dir = dir
    end
  end,
})

return M
