local M = {}

local telescope = require 'telescope'
local actions = require 'telescope.actions'
local actions_layout = require 'telescope.actions.layout'

vim.api.nvim_create_autocmd({ 'User', }, {
  pattern = 'TelescopePreviewerLoaded',
  callback = function()
    vim.opt.number         = true
    vim.opt.relativenumber = true
    vim.opt.wrap           = true
  end,
})

local function five_down()
  return {
    function(prompt_bufnr)
      for _ = 1, 5 do
        actions.move_selection_next(prompt_bufnr)
      end
    end,
    type = 'action',
    opts = { nowait = true, silent = true, desc = '5j', },
  }
end

local function five_up()
  return {
    function(prompt_bufnr)
      for _ = 1, 5 do
        actions.move_selection_previous(prompt_bufnr)
      end
    end,
    type = 'action',
    opts = { nowait = true, silent = true, desc = '5k', },
  }
end

telescope.setup {
  defaults = {
    winblend = 10,
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        preview_cutoff = 0,
        width = 0.92,
        height = 0.92,
      },
    },
    preview = {
      hide_on_startup = false,
      check_mime_type = true,
    },
    mappings = {
      i = {
        ['<C-c>'] = actions.close,

        ['<C-m>'] = actions.select_default,
        ['<CR>'] = actions.select_default,
        ['<C-x>'] = actions.select_horizontal,
        ['<C-v>'] = actions.select_vertical,
        ['<C-t>'] = actions.select_tab,

        ['<C-u>'] = actions.preview_scrolling_up,
        ['<C-d>'] = actions.preview_scrolling_down,

        ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

        ['<C-/>'] = actions.which_key,
        ['<C-_>'] = actions.which_key, -- keys from pressing <C-/>

        ['<C-w>'] = { '<c-s-w>', type = 'command', },

        ['<F5>'] = actions_layout.toggle_preview,

        ['<C-+>'] = {
          [[<c-r>=trim(getreg("+"))<cr>]],
          type = 'command',
          opts = { nowait = true, silent = true, desc = '"+p', },
        },

        ['<C-n>'] = actions.move_selection_next,
        ['<C-p>'] = actions.move_selection_previous,
        ['<Down>'] = actions.move_selection_next,
        ['<Up>'] = actions.move_selection_previous,
        ['<A-j>'] = actions.move_selection_next,
        ['<A-k>'] = actions.move_selection_previous,
        ['<ScrollWheelDown>'] = actions.move_selection_next,
        ['<ScrollWheelUp>'] = actions.move_selection_previous,

        ['<A-s-j>'] = five_down(),
        ['<A-s-k>'] = five_up(),
        ['<C-j>'] = five_down(),
        ['<C-k>'] = five_up(),
        ['<PageDown>'] = five_down(),
        ['<PageUp>'] = five_up(),

        ['<LeftMouse>'] = actions.select_default,
        ['<RightMouse>'] = actions_layout.toggle_preview,
        ['<MiddleMouse>'] = {
          actions.close,
          type = 'action',
          opts = { nowait = true, silent = true, },
        },

      },

      n = {
        ['q'] = actions.close,
        ['<esc>'] = actions.close,

        ['<CR>'] = actions.select_default,
        ['<C-x>'] = actions.select_horizontal,
        ['<C-v>'] = actions.select_vertical,
        ['<C-t>'] = actions.select_tab,

        ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

        ['j'] = actions.move_selection_next,
        ['k'] = actions.move_selection_previous,
        ['H'] = actions.move_to_top,
        ['M'] = actions.move_to_middle,
        ['L'] = actions.move_to_bottom,

        ['<Down>'] = actions.move_selection_next,
        ['<Up>'] = actions.move_selection_previous,
        ['gg'] = actions.move_to_top,
        ['G'] = actions.move_to_bottom,

        ['<C-u>'] = actions.preview_scrolling_up,
        ['<C-d>'] = actions.preview_scrolling_down,

        ['?'] = actions.which_key,

        ['<leader>'] = actions.select_default,

        ['<F5>'] = actions_layout.toggle_preview,

        ['<c-j>'] = five_down(),
        ['<c-k>'] = five_up(),
        ['<PageDown>'] = five_down,
        ['<PageUp>'] = five_up,

        ['<ScrollWheelDown>'] = actions.move_selection_next,
        ['<ScrollWheelUp>'] = actions.move_selection_previous,
        ['<LeftMouse>'] = actions.select_default,
        ['<RightMouse>'] = actions_layout.toggle_preview,
        ['<MiddleMouse>'] = actions.close,

      },
    },
    file_ignore_patterns = {}, -- { '%.svn', 'obj', },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--no-ignore',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--fixed-strings',
    },
    wrap_results = true,
  },
}

-- notify
require 'notify'.setup {
  top_down = false,
  timeout = 3000,
  max_height = function()
    return math.floor(vim.o.lines * 0.75)
  end,
  max_width = function()
    return math.floor(vim.o.columns * 0.75)
  end,
}
vim.notify = require 'notify'

-- git_diffs
telescope.load_extension 'git_diffs'

-- ui-select
telescope.load_extension 'ui-select'

-- projects
telescope.load_extension 'projects'

require 'project_nvim'.setup {
  manual_mode = false,
  detection_methods = { 'pattern', 'lsp', },
  patterns = { '.git', },
}

function M.projects()
  vim.cmd 'Telescope projects'
  vim.cmd [[call feedkeys("\<esc>\<esc>")]]
  vim.keymap.set({ 'n', 'v', }, '<leader>sk', function()
    vim.cmd 'Telescope projects'
  end, { silent = true, desc = 'Telescope projects', })
  vim.fn.timer_start(20, function()
    vim.cmd [[call feedkeys(":Telescope projects\<cr>")]]
  end)
end

-- mappings

require 'which-key'.register { ['<leader>s'] = { name = 'nvim.telescope', }, }
require 'which-key'.register { ['<leader>sb'] = { name = 'nvim.telescope.buffers', }, }

-- builtins
function M.buffers_all() vim.cmd 'Telescope buffers' end

function M.buffers_cur() vim.cmd 'Telescope buffers cwd_only=true sort_mru=true ignore_current_buffer=true' end

function M.find_files() vim.cmd 'Telescope find_files' end

function M.live_grep() vim.cmd 'Telescope live_grep' end

return M
