local M = {}

local B = require 'base'

M.FIX = { 'FIX', 'FIXME', 'BUG', 'FIXIT', 'ISSUE', }
M.WARN = { 'WARN', 'WARNING', 'XXX', }
M.PERF = { 'PERF', 'OPTIM', 'PERFORMANCE', 'OPTIMIZE', }
M.NOTE = { 'NOTE', 'INFO', }
M.TEST = { 'TEST', 'TESTING', 'PASSED', 'FAILED', }

require 'todo-comments'.setup {
  keywords = {
    FIX = {
      icon = ' ',
      color = 'error',
      alt = M.FIX,
    },
    TODO = { icon = ' ', color = 'info', },
    HACK = { icon = ' ', color = 'warning', },
    WARN = { icon = ' ', color = 'warning', alt = M.WARN, },
    PERF = { icon = ' ', alt = M.PERF, },
    NOTE = { icon = ' ', color = 'hint', alt = M.NOTE, },
    TEST = { icon = '⏲ ', color = 'test', alt = M.TEST, },
  },
}

function M.TodoQuickFix(keywords)
  if not keywords then
    vim.cmd 'TodoQuickFix'
  else
    if type(keywords) == 'string' then
      keywords = { keywords, }
    end
    B.cmd('TodoQuickFix keywords=%s', vim.fn.join(keywords, ','))
  end
end

function M.TodoTelescope(keywords)
  if not keywords then
    vim.cmd 'TodoTelescope'
  else
    if type(keywords) == 'string' then
      keywords = { keywords, }
    end
    B.cmd('TodoTelescope keywords=%s', vim.fn.join(keywords, ','))
  end
end

function M.TodoLocList(keywords)
  if not keywords then
    vim.cmd 'TodoLocList'
  else
    if type(keywords) == 'string' then
      keywords = { keywords, }
    end
    B.cmd('TodoLocList keywords=%s', vim.fn.join(keywords, ','))
  end
end

-- mappings
B.del_map({ 'n', 'v', }, '<leader>t')
B.del_map({ 'n', 'v', }, '<leader>tl')
B.del_map({ 'n', 'v', }, '<leader>tt')
B.del_map({ 'n', 'v', }, '<leader>tq')

require 'which-key'.register { ['<leader>t'] = { name = 'test.todo', }, }
require 'which-key'.register { ['<leader>tl'] = { name = 'test.todo.locallist', }, }
require 'which-key'.register { ['<leader>tt'] = { name = 'test.todo.telescope', }, }
require 'which-key'.register { ['<leader>tq'] = { name = 'test.todo.quickfix', }, }

B.lazy_map {
  { '<leader>tqq', function() M.TodoQuickFix() end,        mode = { 'n', 'v', }, desc = 'TodoQuickFix ALL', },
  { '<leader>tqf', function() M.TodoQuickFix(M.FIX) end,   mode = { 'n', 'v', }, desc = 'TodoQuickFix FIX', },
  { '<leader>tqt', function() M.TodoQuickFix 'TODO' end,   mode = { 'n', 'v', }, desc = 'TodoQuickFix TODO', },
  { '<leader>tqh', function() M.TodoQuickFix 'HACK' end,   mode = { 'n', 'v', }, desc = 'TodoQuickFix HACK', },
  { '<leader>tqw', function() M.TodoQuickFix(M.WARN) end,  mode = { 'n', 'v', }, desc = 'TodoQuickFix WARN', },
  { '<leader>tqp', function() M.TodoQuickFix(M.PERF) end,  mode = { 'n', 'v', }, desc = 'TodoQuickFix PERF', },
  { '<leader>tqn', function() M.TodoQuickFix(M.NOTE) end,  mode = { 'n', 'v', }, desc = 'TodoQuickFix NOTE', },
  { '<leader>tqs', function() M.TodoQuickFix(M.TEST) end,  mode = { 'n', 'v', }, desc = 'TodoQuickFix TEST', },

  { '<leader>ttt', function() M.TodoTelescope() end,       mode = { 'n', 'v', }, desc = 'TodoTelescope ALL', },
  { '<leader>ttf', function() M.TodoTelescope(M.FIX) end,  mode = { 'n', 'v', }, desc = 'TodoTelescope FIX', },
  { '<leader>ttt', function() M.TodoTelescope 'TODO' end,  mode = { 'n', 'v', }, desc = 'TodoTelescope TODO', },
  { '<leader>tth', function() M.TodoTelescope 'HACK' end,  mode = { 'n', 'v', }, desc = 'TodoTelescope HACK', },
  { '<leader>ttw', function() M.TodoTelescope(M.WARN) end, mode = { 'n', 'v', }, desc = 'TodoTelescope WARN', },
  { '<leader>ttp', function() M.TodoTelescope(M.PERF) end, mode = { 'n', 'v', }, desc = 'TodoTelescope PERF', },
  { '<leader>ttn', function() M.TodoTelescope(M.NOTE) end, mode = { 'n', 'v', }, desc = 'TodoTelescope NOTE', },
  { '<leader>tts', function() M.TodoTelescope(M.TEST) end, mode = { 'n', 'v', }, desc = 'TodoTelescope TEST', },

  { '<leader>tll', function() M.TodoLocList() end,         mode = { 'n', 'v', }, desc = 'TodoLocList ALL', },
  { '<leader>tlf', function() M.TodoLocList(M.FIX) end,    mode = { 'n', 'v', }, desc = 'TodoLocList FIX', },
  { '<leader>tlt', function() M.TodoLocList 'TODO' end,    mode = { 'n', 'v', }, desc = 'TodoLocList TODO', },
  { '<leader>tlh', function() M.TodoLocList 'HACK' end,    mode = { 'n', 'v', }, desc = 'TodoLocList HACK', },
  { '<leader>tlw', function() M.TodoLocList(M.WARN) end,   mode = { 'n', 'v', }, desc = 'TodoLocList WARN', },
  { '<leader>tlp', function() M.TodoLocList(M.PERF) end,   mode = { 'n', 'v', }, desc = 'TodoLocList PERF', },
  { '<leader>tln', function() M.TodoLocList(M.NOTE) end,   mode = { 'n', 'v', }, desc = 'TodoLocList NOTE', },
  { '<leader>tls', function() M.TodoLocList(M.TEST) end,   mode = { 'n', 'v', }, desc = 'TodoLocList TEST', },
}

return M
