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

function M.leader_d()
  TimingBegin()
  require 'which-key'.register {
    ['<leader>d'] = { name = 'nvim/qf', },
    ['<leader>dw'] = { function() require 'config.my.git'.open_prev_item() end, 'quick open: qf prev item', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ds'] = { function() require 'config.my.git'.open_next_item() end, 'quick open: qf next item', mode = { 'n', 'v', }, silent = true, },
    ['<leader>dj'] = { function() require 'config.test.nvimtree'.open_next_tree_node() end, 'quick open: nvimtree next node', mode = { 'n', 'v', }, silent = true, },
    ['<leader>dk'] = { function() require 'config.test.nvimtree'.open_prev_tree_node() end, 'quick open: nvimtree prev node', mode = { 'n', 'v', }, silent = true, },
    ['<leader>do'] = { function() require 'config.test.nvimtree'.open_all() end, 'nvimtree: open_all', mode = { 'n', 'v', }, silent = true, },
    ['<leader>de'] = { function() require 'config.test.nvimtree'.refresh_hl() end, 'nvimtree: refresh hl', mode = { 'n', 'v', }, silent = true, },
    ['<leader>da'] = { function() require 'config.test.nvimtree'.ausize_toggle() end, 'nvimtree: ausize toggle', mode = { 'n', 'v', }, silent = true, },
    ['<leader>dc'] = { function() require 'config.test.nvimtree'.toggle_cur_root() end, 'nvimtree: toggle cur root', mode = { 'n', 'v', }, silent = true, },
    ['<leader>dr'] = { function() require 'config.test.nvimtree'.reset_nvimtree() end, 'nvimtree: reset nvimtree', mode = { 'n', }, silent = true, },
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
  M.leader_d()
end

return M
