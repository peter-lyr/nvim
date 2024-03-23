-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/16 20:10:17 星期六

local M = {}

function M.base()
  TimingBegin()
  require 'which-key'.register {
    ['<c-;>'] = { function()
      local B = require 'base'
      if not B.commands then
        B.create_user_command_with_M(BaseCommand())
      end
      B.all_commands()
    end, 'base: all commands', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M._m(items)
  for _, item in ipairs(items) do
    local lhs = table.remove(item, 1)
    if not item['name'] then
      item[#item + 1] = item['desc']
    end
    require 'which-key'.register { [lhs] = item, }
  end
end

function M.lsp()
  TimingBegin()
  require 'which-key'.register {
    ['<leader>f'] = { name = 'lsp', },
    ['<leader>fv'] = { name = 'lsp.more', },
    ['<leader>fn'] = { function() require 'config.nvim.lsp'.rename() end, 'lsp: rename', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.tabline()
  TimingBegin()
  require 'which-key'.register {
    ['<leader><c-s-l>'] = { function() require 'config.my.tabline'.bd_next_buf(1) end, 'my.tabline: bwipeout_next_buf ', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-s-h>'] = { function() require 'config.my.tabline'.bd_prev_buf(1) end, 'my.tabline: bwipeout_prev_buf', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-s-.>'] = { function() require 'config.my.tabline'.bd_all_next_buf(1) end, 'my.tabline: bwipeout_all_next_buf', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-s-,>'] = { function() require 'config.my.tabline'.bd_all_prev_buf(1) end, 'my.tabline: bwipeout_all_prev_buf', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.q()
  TimingBegin()
  require 'which-key'.register {
    ['q'] = { name = 'tabline', },
    qh = { function() require 'config.my.tabline'.restore_hidden_tabs() end, 'my.tabline: restore_hidden_tabs', mode = { 'n', 'v', }, silent = true, },
    qk = { function() require 'config.my.tabline'.append_one_proj_new_tab_no_dupl() end, 'my.tabline: append_one_proj_new_tab_no_dupl', mode = { 'n', 'v', }, silent = true, },
    qm = { function() require 'config.my.tabline'.restore_hidden_stack_main() end, 'my.tabline: restore_hidden_tabs', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.all(force)
  if M.loaded and not force then
    return
  end
  M.loaded = 1
  M.base()
  M.lsp()
  M.q()
end

return M
