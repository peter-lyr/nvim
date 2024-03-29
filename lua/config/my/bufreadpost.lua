-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/01/05 12:26:21 Friday

local M = {}

local B = require 'base'

HL()

B.aucmd('BufReadPost', 'my.bufreadpost.BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

local tab_4_fts = {
  'c', 'cpp',
  'python',
  'ld',
}

B.aucmd('BufEnter', 'my.bufreadpost.BufEnter', {
  callback = function(ev)
    if vim.fn.filereadable(ev.file) == 1 and vim.o.modifiable == true then
      vim.opt.cursorcolumn = true
    end
    if vim.tbl_contains(tab_4_fts, vim.opt.filetype:get()) == true then
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
    else
      vim.opt.tabstop = 2
      vim.opt.softtabstop = 2
      vim.opt.shiftwidth = 2
    end
    local ext = string.match(B.buf_get_name_0(), '%.([^.]+)$')
    if ext == 'xxd' then
      vim.cmd 'setlocal ft=xxd'
    end
  end,
})

M.fs = {
  ['md'] = function()
    vim.fn.append('$', {
      '',
      string.format('# %s', vim.fn.strftime '%y%m%d-%Hh%Mm'),
    })
    vim.lsp.buf.format()
    vim.cmd 'norm Gw'
  end,
  ['lua'] = function()
    vim.fn.append('$', {
      '',
      'local M = {}',
      '',
      "local B = require 'base'",
      '',
      "M.source = B.getsource(debug.getinfo(1)['source'])",
      "M.lua = B.getlua(M.source)",
      '',
      'return M',
    })
  end,
  ['py'] = function()
    vim.fn.append('$', {
      '',
      'if __name__ == "__main__":',
      '    pass',
    })
  end,
  ['c'] = function()
    vim.fn.append('$', {
      '',
      '#include <stdio.h>',
      '',
      'int main(int argc, char *argv[])',
      '{',
      '    return 0;',
      '}',
    })
  end,
}

B.aucmd({ 'BufReadPre', }, 'my.bufreadpost.BufReadPre', {
  callback = function(ev)
    local file = vim.api.nvim_buf_get_name(ev.buf)
    if vim.fn.getfsize(file) == 0 then
      B.set_timeout(10, function()
        vim.cmd 'norm ggdG'
        vim.fn.setline(1, {
          string.format('Copyright (c) %s %s. All Rights Reserved.', vim.fn.strftime '%Y', 'liudepei'),
          vim.fn.strftime 'create at %Y/%m/%d %H:%M:%S %A',
        })
        vim.cmd 'norm gcip'
        local ext = string.match(file, '%.([^.]+)$')
        local callback = M.fs[ext]
        if callback then
          callback()
        else
          vim.cmd 'norm Go'
          vim.cmd 'norm S'
        end
      end)
    end
  end,
})

return M
