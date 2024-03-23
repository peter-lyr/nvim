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

function M.toggle()
  TimingBegin()
  require 'which-key'.register {
    ['<leader>t'] = { name = 'toggle', },
    ['<leader>td'] = { function() require 'config.my.toggle'.diff() end, 'diff', mode = { 'n', 'v', }, silent = true, },
    ['<leader>tw'] = { function() require 'config.my.toggle'.wrap() end, 'wrap', mode = { 'n', 'v', }, silent = true, },
    ['<leader>tn'] = { function() require 'config.my.toggle'.nu() end, 'nu', mode = { 'n', 'v', }, silent = true, },
    ['<leader>tr'] = { function() require 'config.my.toggle'.renu() end, 'renu', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ts'] = { function() require 'config.my.toggle'.signcolumn() end, 'signcolumn', mode = { 'n', 'v', }, silent = true, },
    ['<leader>tc'] = { function() require 'config.my.toggle'.conceallevel() end, 'conceallevel', mode = { 'n', 'v', }, silent = true, },
    ['<leader>tk'] = { function() require 'config.my.toggle'.iskeyword() end, 'iskeyword', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
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

function M.git()
  TimingBegin()
  require 'which-key'.register {
    ['<leader>g'] = { name = 'git', },
    ['<leader>gt'] = { name = 'git.telescope', },
    ['<leader>gtb'] = { function() require 'config.nvim.telescope'.git_bcommits() end, 'git.telescope: bcommits', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gtc'] = { function() require 'config.nvim.telescope'.git_commits() end, 'git.telescope: commits', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gh'] = { function() require 'config.nvim.telescope'.git_branches() end, 'git.telescope: branches', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gg'] = { name = 'git.push', },
    ['<leader>gga'] = { function() require 'config.my.git'.addcommitpush(nil, 1) end, 'git.push: addcommitpush commit_history_en', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gc'] = { function() require 'config.my.git'.commit_push() end, 'git.push: commit_push', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggc'] = { function() require 'config.my.git'.commit_push(nil, 1) end, 'git.push: commit_push commit_history_en', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gp'] = { function() require 'config.my.git'.pull() end, 'git.push: pull', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gb'] = { function() require 'config.my.git'.git_browser() end, 'git.push: browser', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggs'] = { function() require 'config.my.git'.push() end, 'git.push: push', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggg'] = { function() require 'config.my.git'.graph_asyncrun() end, 'git.push: graph_asyncrun', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gg<c-g>'] = { function() require 'config.my.git'.graph_start() end, 'git.push: graph_start', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggv'] = { function() require 'config.my.git'.init() end, 'git.push: init', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-a>'] = { function() require 'config.my.git'.addall() end, 'git.push: addall', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggr'] = { function() require 'config.my.git'.reset_hard() end, 'git.push: reset_hard', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggd'] = { function() require 'config.my.git'.reset_hard_clean() end, 'git.push: reset_hard_clean', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggD'] = { function() require 'config.my.git'.clean_ignored_files_and_folders() end, 'git.push: clean_ignored_files_and_folders', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggC'] = { function() require 'config.my.git'.clone() end, 'git.push: clone', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggh'] = { function() require 'config.my.git'.show_commit_history() end, 'git.push: show_commit_history', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-l>'] = { function() require 'config.my.git'.addcommitpush_curline() end, 'git.push: addcommitpush curline', mode = { 'n', 'v', }, silent = true, },
    ["<leader>g<c-'>"] = { function() require 'config.my.git'.addcommitpush_single_quote() end, 'git.push: addcommitpush single_quote', mode = { 'n', 'v', }, silent = true, },
    ["<leader>g<c-s-'>"] = { function() require 'config.my.git'.addcommitpush_double_quote() end, 'git.push: addcommitpush double_quote', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-0>'] = { function() require 'config.my.git'.addcommitpush_parentheses() end, 'git.push: addcommitpush parentheses', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-]>'] = { function() require 'config.my.git'.addcommitpush_bracket() end, 'git.push: addcommitpush bracket', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-s-]>'] = { function() require 'config.my.git'.addcommitpush_brace() end, 'git.push: addcommitpush brace', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-`>'] = { function() require 'config.my.git'.addcommitpush_back_quote() end, 'git.push: addcommitpush back_quote', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-s-.>'] = { function() require 'config.my.git'.addcommitpush_angle_bracket() end, 'git.push: addcommitpush angle_bracket', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-e>'] = { function() require 'config.my.git'.addcommitpush_cword() end, 'git.push: addcommitpush cword', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-4>'] = { function() require 'config.my.git'.addcommitpush_cWORD() end, 'git.push: addcommitpush cWORD', mode = { 'n', 'v', }, silent = true, },
    g = { name = 'git.push', },
    ['g<c-l>'] = { function() require 'config.my.git'.addcommitpush_curline() end, 'git.push: addcommitpush curline', mode = { 'n', 'v', }, silent = true, },
    ["g<c-'>"] = { function() require 'config.my.git'.addcommitpush_single_quote() end, 'git.push: addcommitpush single_quote', mode = { 'n', 'v', }, silent = true, },
    ["g<c-s-'>"] = { function() require 'config.my.git'.addcommitpush_double_quote() end, 'git.push: addcommitpush double_quote', mode = { 'n', 'v', }, silent = true, },
    ['g<c-0>'] = { function() require 'config.my.git'.addcommitpush_parentheses() end, 'git.push: addcommitpush parentheses', mode = { 'n', 'v', }, silent = true, },
    ['g<c-]>'] = { function() require 'config.my.git'.addcommitpush_bracket() end, 'git.push: addcommitpush bracket', mode = { 'n', 'v', }, silent = true, },
    ['g<c-s-]>'] = { function() require 'config.my.git'.addcommitpush_brace() end, 'git.push: addcommitpush brace', mode = { 'n', 'v', }, silent = true, },
    ['g<c-`>'] = { function() require 'config.my.git'.addcommitpush_back_quote() end, 'git.push: addcommitpush back_quote', mode = { 'n', 'v', }, silent = true, },
    ['g<c-s-.>'] = { function() require 'config.my.git'.addcommitpush_angle_bracket() end, 'git.push: addcommitpush angle_bracket', mode = { 'n', 'v', }, silent = true, },
    ['g<c-e>'] = { function() require 'config.my.git'.addcommitpush_cword() end, 'git.push: addcommitpush cword', mode = { 'n', 'v', }, silent = true, },
    ['g<c-4>'] = { function() require 'config.my.git'.addcommitpush_cWORD() end, 'git.push: addcommitpush cWORD', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gv'] = { name = 'git.diffview', },
    ['<leader>gv1'] = { function() require 'config.my.git'.diffview_filehistory(1) end, 'git.diffview: filehistory 16', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gv2'] = { function() require 'config.my.git'.diffview_filehistory(2) end, 'git.diffview: filehistory 64', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gv3'] = { function() require 'config.my.git'.diffview_filehistory(3) end, 'git.diffview: filehistory finite', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gvs'] = { function() require 'config.my.git'.diffview_stash() end, 'git.diffview: filehistory stash', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gvo'] = { function() require 'config.my.git'.diffview_open() end, 'git.diffview: open', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gvq'] = { function() require 'config.my.git'.diffview_close() end, 'git.diffview: close', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gvl'] = { ':<c-u>DiffviewRefresh<cr>', 'git.diffview: refresh', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gvw'] = { ':<c-u>Telescope git_diffs diff_commits<cr>', 'git.diffview: Telescope git_diffs diff_commits', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gm'] = { name = 'git.signs', },
    ['<leader>gmt'] = { name = 'git.signs.toggle', },
    ['<leader>ge'] = { function() require 'config.my.git'.toggle_deleted() end, 'my.git.signs: toggle_deleted', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gmd'] = { function() require 'config.my.git'.diffthis_l() end, 'my.git.signs: diffthis_l', mode = { 'n', 'v', }, },
    ['<leader>gmr'] = { function() require 'config.my.git'.reset_buffer() end, 'my.git.signs: reset_buffer', mode = { 'n', 'v', }, },
    ['<leader>gms'] = { function() require 'config.my.git'.stage_buffer() end, 'my.git.signs: stage_buffer', mode = { 'n', 'v', }, },
    ['<leader>gmb'] = { function() require 'config.my.git'.blame_line() end, 'my.git.signs: blame_line', mode = { 'n', 'v', }, },
    ['<leader>gmp'] = { function() require 'config.my.git'.preview_hunk() end, 'my.git.signs: preview_hunk', mode = { 'n', 'v', }, },
    ['<leader>gmtb'] = { function() require 'config.my.git'.toggle_current_line_blame() end, 'my.git.signs: toggle_current_line_blame', mode = { 'n', 'v', }, },
    ['<leader>gmtd'] = { function() require 'config.my.git'.toggle_deleted() end, 'my.git.signs: toggle_deleted', mode = { 'n', 'v', }, },
    ['<leader>gmtl'] = { function() require 'config.my.git'.toggle_linehl() end, 'my.git.signs: toggle_linehl', mode = { 'n', 'v', }, },
    ['<leader>gmtn'] = { function() require 'config.my.git'.toggle_numhl() end, 'my.git.signs: toggle_numhl', mode = { 'n', 'v', }, },
    ['<leader>gmts'] = { function() require 'config.my.git'.toggle_signs() end, 'my.git.signs: toggle_signs', mode = { 'n', 'v', }, },
    ['<leader>gmtw'] = { function() require 'config.my.git'.toggle_word_diff() end, 'my.git.signs: toggle_word_diff', mode = { 'n', 'v', }, },
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
    ['<leader>dw'] = { function() require 'config.myy.git'.open_prev_item() end, 'quick open: qf prev item', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ds'] = { function() require 'config.myy.git'.open_next_item() end, 'quick open: qf next item', mode = { 'n', 'v', }, silent = true, },
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
  M.toggle()
  M.lsp()
  M.git()
  M.q()
  M.leader_d()
end

return M
