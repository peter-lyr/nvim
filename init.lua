vim.g.pswd = 'anyPydF8UCoErXNu'
vim.g.start_time = vim.fn.reltime()
vim.g.mapleader = ' '
vim.o.shada = nil

local vimruntime = vim.fn.expand '$VIMRUNTIME'
local data = vim.fn.stdpath 'data' .. '\\'

local lazypath = data .. 'site\\pack\\lazy\\start\\lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
  vim.opt.rtp:prepend(lazypath)
end

require 'func'

local root = data .. 'lazy\\plugins'
local lockfile = data .. 'lazy-lock.json'

require 'lazy'.setup {
  defaults = { lazy = true, },
  spec = { { import = 'plugins', }, },
  root = root,
  readme = { enabled = false, },
  lockfile = lockfile,
  performance = {
    rtp = {
      paths = { string.sub(vimruntime, 1, #vimruntime - 12) .. 'nvim-qt\\runtime', },
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  checker = {
    enabled = false,
  },
  change_detection = {
    enabled = false,
  },
  ui = {
    icons = {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
    custom_keys = {
      ['<localleader>l'] = false,
      ['<localleader>t'] = false,
    },
  },
}
