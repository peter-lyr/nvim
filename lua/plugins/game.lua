-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/01/20 22:58:31 星期六

return {
  {
    'alec-gibson/nvim-tetris',
    cmd = { 'Tetris', },
  },

  {
    'zyedidia/vim-snake',
    cmd = { 'Snake', 'SnakeStart', 'SnakeStop', },
    -- error: k l will restart
    config = function()
      local function stop()
        vim.cmd [[
          augroup SnakeUpdate
            au!
          augroup END
        ]]
        vim.cmd 'bw!'
      end
      vim.api.nvim_create_user_command('SnakeStart', function()
        vim.cmd 'Snake'
        vim.cmd [[
          map <buffer><nowait> s :call Down()<CR>
          map <buffer><nowait> a :call Left()<CR>
          map <buffer><nowait> w :call Up()<CR>
          map <buffer><nowait> d :call Right()<CR>
          ]]
        require 'base'.lazy_map {
          { 'qq', stop, mode = { 'n', 'v', }, buffer = vim.fn.bufnr(), silent = true, nowait = true, desc = 'game.snake: Stop', },
        }
      end, { nargs = 0, })
    end,
  },

  {
    'peter-lyr/killersheep.nvim',
    cmd = 'KillKillKill',
    config = function()
      -- cannon.shoot_time = loop.hrtime() + 800000000
      -- let 800000000 smaller
      require 'killersheep'.setup {
        gore = true,        -- Enables/disables blood and gore.
        keymaps = {
          move_left = 'h',  -- Keymap to move cannon to the left.
          move_right = 'l', -- Keymap to move cannon to the right.
          shoot = 's',      -- Keymap to shoot the cannon.
        },
      }
    end,
  },

}