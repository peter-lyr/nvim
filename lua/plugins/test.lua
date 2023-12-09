return {

  -- startuptime
  { 'dstein64/vim-startuptime', cmd = 'StartupTime', },

  -- colorscheme
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 200,
    config = function()
      require 'onedark'.load()
    end,
  },

}
