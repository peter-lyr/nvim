local M = {}

local B = require 'base'

M.treesitter_parser = B.getcreate_stddata_dirpath 'treesitter_parser'.filename

vim.opt.runtimepath:append(M.treesitter_parser)

-- function M.disable(lang, buf)
function M.disable(_, buf)
  local max_filesize = 1000 * 1024
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
end

require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'c',
    'python',
    'lua',
    'markdown', 'markdown_inline',
  },
  sync_install = false,
  auto_install = false,
  parser_install_dir = M.treesitter_parser,
  highlight = {
    enable = true,
    disable = M.disable,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = M.disable,
  },
  incremental_selection = {
    enable = true,
    disable = M.disable,
    keymaps = {
      init_selection = 'qi',
      node_incremental = 'qi',
      scope_incremental = 'qu',
      node_decremental = 'qo',
    },
  },
  rainbow = {
    enable = true,
    disable = M.disable,
    extended_mode = true,
    max_file_lines = nil,
  },
  matchup = {
    enable = true,
    disable = M.disable,
  },
}

require 'rainbow.internal'.defhl()

require 'treesitter-context'.setup {
  zindex = 1,
  on_attach = function()
    local max_filesize = 1000 * 1024
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > max_filesize then
      return false
    end
    return true
  end,
}

vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

require 'match-up'.setup {}

B.aucmd({ 'TabClosed', 'TabEnter', }, 'nvim.treesitter.TabClosed', {
  callback = function()
    B.set_timeout(50, function()
      if string.match(vim.bo.ft, 'Diffview') or vim.opt.diff:get() == true then
        vim.cmd 'TSDisable rainbow'
      else
        vim.cmd 'TSEnable rainbow'
      end
    end)
  end,
})
