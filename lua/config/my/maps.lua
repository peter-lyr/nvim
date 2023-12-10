-- cmdline
vim.keymap.set({ 'n', 'v', }, '<leader>;', ':', { silent = false, desc = 'my.maps: cmdline', })

-- record
vim.keymap.set({ 'n', 'v', }, 'q', '<nop>', { silent = true, desc = 'my.maps: <nop>', })
vim.keymap.set({ 'n', 'v', }, 'Q', 'q', { silent = true, desc = 'my.maps: q', })

-- c.
vim.keymap.set({ 'n', 'v', }, 'c.', '<cmd>cd %:h<cr>', { silent = true, desc = 'my.maps: cd %:h', })

-- undo
vim.keymap.set({ 'n', }, 'U', '<c-r>', { silent = true, desc = 'my.maps: redo', })

-- scroll horizontally
vim.keymap.set({ 'n', 'v', }, '<S-ScrollWheelDown>', '10zl', { silent = false, desc = 'my.maps: scroll right horizontally', })
vim.keymap.set({ 'n', 'v', }, '<S-ScrollWheelUp>', '10zh', { silent = false, desc = 'my.maps: scroll left horizontally', })

-- e!
vim.keymap.set({ 'n', 'v', }, 'qq', '<cmd>e!<cr>', { silent = true, desc = 'my.maps: e!', })

-- cursor
vim.keymap.set({ 'n', 'v', }, '<c-j>', '5j', { silent = true, desc = 'my.maps: 5j', })
vim.keymap.set({ 'n', 'v', }, '<c-k>', '5k', { silent = true, desc = 'my.maps: 5k', })

-- copy_paste
vim.keymap.set({ 'n', 'v', }, '<a-y>', '"+y', { silent = true, desc = 'my.maps: "+y', })
vim.keymap.set({ 'n', 'v', }, '<a-d>', '"+d', { silent = true, desc = 'my.maps: "+d', })
vim.keymap.set({ 'n', 'v', }, '<a-c>', '"+c', { silent = true, desc = 'my.maps: "+c', })
vim.keymap.set({ 'n', 'v', }, '<a-p>', '"+p', { silent = true, desc = 'my.maps: "+p', })
vim.keymap.set({ 'n', 'v', }, '<a-s-p>', '"+P', { silent = true, desc = 'my.maps: "+P', })

-- for youdao dict
vim.keymap.set({ 'v', }, '<c-c>', '"+y', { silent = true, desc = 'my.maps: "+y', })

vim.cmd [[
cab xpx sort
cab xqc g/^\(.*\)$\n\1$/d
cab xpq sort\|g/^\(.*\)$\n\1$/d
]]
