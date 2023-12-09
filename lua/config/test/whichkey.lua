local M = {}

function M.setup()
  require 'which-key'.setup {
    window = {
      border = 'single',
      winblend = 12,
    },
    layout = {
      height = { min = 4, max = 80, },
      width = { min = 20, max = 200, },
    },
  }
end

return M
