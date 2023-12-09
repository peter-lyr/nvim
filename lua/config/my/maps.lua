-- cmdline
vim.keymap.set({ 'n', 'v', }, '<leader>;', ':', { silent = false, desc = 'cmdline', })

-- record
vim.keymap.set({ 'n', 'v', }, 'q', '<nop>', { silent = true, desc = '<nop>', })
vim.keymap.set({ 'n', 'v', }, 'Q', 'q', { silent = true, desc = 'q', })

-- c.
vim.keymap.set({ 'n', 'v', }, 'c.', '<cmd>cd %:h<cr>', { silent = true, desc = 'cd %:h', })

-- undo
vim.keymap.set({ 'n', }, 'U', '<c-r>', { silent = true, desc = 'redo', })

-- scroll horizontally
vim.keymap.set({ 'n', 'v', }, '<S-ScrollWheelDown>', '10zl', { silent = false, desc = 'scroll right horizontally', })
vim.keymap.set({ 'n', 'v', }, '<S-ScrollWheelUp>', '10zh', { silent = false, desc = 'scroll left horizontally', })

-- e!
vim.keymap.set({ 'n', 'v', }, 'qq', '<cmd>e!<cr>', { silent = true, desc = 'e!', })

-- cursor
vim.keymap.set({ 'n', 'v', }, '<c-j>', '5j', { silent = true, desc = '5j', })
vim.keymap.set({ 'n', 'v', }, '<c-k>', '5k', { silent = true, desc = '5k', })

-- copy_paste
vim.keymap.set({ 'n', 'v', }, '<a-y>', '"+y', { silent = true, desc = '"+y', })
vim.keymap.set({ 'n', 'v', }, '<a-d>', '"+d', { silent = true, desc = '"+d', })
vim.keymap.set({ 'n', 'v', }, '<a-c>', '"+c', { silent = true, desc = '"+c', })
vim.keymap.set({ 'n', 'v', }, '<a-p>', '"+p', { silent = true, desc = '"+p', })
vim.keymap.set({ 'n', 'v', }, '<a-s-p>', '"+P', { silent = true, desc = '"+P', })

-- for youdao dict
vim.keymap.set({ 'v', }, '<c-c>', '"+y', { silent = true, desc = '"+y', })

vim.cmd [[
cab xpx sort
cab xqc g/^\(.*\)$\n\1$/d
cab xpq sort\|g/^\(.*\)$\n\1$/d
]]
