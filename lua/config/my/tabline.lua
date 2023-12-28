local M = {}

local B = require 'base'

M.proj_bufs = {}
M.proj_buf = {}
M.cur_proj = ''
M.cur_buf = 0

M.simple_statusline = nil

function M.is_cuf_buf_readable()
  if vim.fn.filewritable(vim.api.nvim_buf_get_name(0)) == 1 then
    return 1
  end
  return nil
end

function M.b_prev_buf()
  if not M.is_cuf_buf_readable() then
    return
  end
  if M.proj_bufs[M.cur_proj] then
    local index
    if vim.v.count ~= 0 then
      index = vim.v.count
    else
      index = B.index_of(M.proj_bufs[M.cur_proj], M.cur_buf) - 1
    end
    if index < 1 then
      index = #M.proj_bufs[M.cur_proj]
    end
    local buf = M.proj_bufs[M.cur_proj][index]
    if buf then
      B.cmd('b%d', buf)
    end
    M.update_bufs_and_refresh_tabline()
  end
end

function M.b_next_buf()
  if not M.is_cuf_buf_readable() then
    return
  end
  if M.proj_bufs[M.cur_proj] then
    local index
    if vim.v.count ~= 0 then
      index = vim.v.count
    else
      index = B.index_of(M.proj_bufs[M.cur_proj], M.cur_buf) + 1
    end
    if index > #M.proj_bufs[M.cur_proj] then
      index = 1
    end
    local buf = M.proj_bufs[M.cur_proj][index]
    if buf then
      B.cmd('b%d', buf)
    end
    M.update_bufs_and_refresh_tabline()
  end
end

function M.bd_prev_buf()
  if not M.is_cuf_buf_readable() then
    return
  end
  if #M.proj_bufs[M.cur_proj] > 0 then
    local index = B.index_of(M.proj_bufs[M.cur_proj], M.cur_buf)
    if index <= 1 then
      return
    end
    index = index - 1
    local buf = M.proj_bufs[M.cur_proj][index]
    if buf then
      B.cmd('Bdelete! %d', buf)
    end
    M.update_bufs_and_refresh_tabline()
  end
end

function M.bd_next_buf()
  if not M.is_cuf_buf_readable() then
    return
  end
  if #M.proj_bufs[M.cur_proj] > 0 then
    local index = B.index_of(M.proj_bufs[M.cur_proj], M.cur_buf)
    if index >= #M.proj_bufs[M.cur_proj] then
      return
    end
    index = index + 1
    local buf = M.proj_bufs[M.cur_proj][index]
    if buf then
      B.cmd('Bdelete! %d', buf)
    end
    M.update_bufs_and_refresh_tabline()
  end
end

function M.bd_all_next_buf()
  if not M.is_cuf_buf_readable() then
    return
  end
  if #M.proj_bufs[M.cur_proj] > 0 then
    local index = B.index_of(M.proj_bufs[M.cur_proj], M.cur_buf)
    if index >= #M.proj_bufs[M.cur_proj] then
      return
    end
    index = index + 1
    local bufs = {}
    for i = index, #M.proj_bufs[M.cur_proj] do
      local buf = M.proj_bufs[M.cur_proj][i]
      if buf then
        bufs[#bufs + 1] = buf
      end
    end
    for _, buf in ipairs(bufs) do
      B.cmd('Bdelete! %d', buf)
    end
    M.update_bufs_and_refresh_tabline()
  end
end

function M.bd_all_prev_buf()
  if not M.is_cuf_buf_readable() then
    return
  end
  if #M.proj_bufs[M.cur_proj] > 0 then
    local index = B.index_of(M.proj_bufs[M.cur_proj], M.cur_buf)
    if index <= 1 then
      return
    end
    index = index - 1
    local bufs = {}
    for i = 1, index do
      local buf = M.proj_bufs[M.cur_proj][i]
      if buf then
        bufs[#bufs + 1] = buf
      end
    end
    for _, buf in ipairs(bufs) do
      B.cmd('Bdelete! %d', buf)
    end
    M.update_bufs_and_refresh_tabline()
  end
end

function M.only_cur_buffer()
  pcall(vim.cmd, 'tabo')
  pcall(vim.cmd, 'wincmd o')
  pcall(vim.cmd, 'e!')
end

function M.restore_hidden_tabs()
  pcall(vim.cmd, 'tabo')
  pcall(vim.cmd, 'wincmd o')
  if #vim.tbl_keys(M.proj_bufs) > 1 then
    local temp = B.rep_slash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
    for _, project in ipairs(vim.tbl_keys(M.proj_buf)) do
      if project ~= temp and vim.fn.buflisted(M.proj_buf[project]) == 1 then
        vim.cmd 'wincmd v'
        vim.cmd 'wincmd T'
        vim.cmd('b' .. M.proj_buf[project])
      end
    end
    vim.cmd '1tabnext'
  end
end

function M.append_one_proj_right_down()
  if #vim.tbl_keys(M.proj_bufs) > 1 then
    local projs = {}
    local active_projs = {}
    for winnr = 1, vim.fn.winnr '$' do
      local tt = B.rep_slash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(vim.fn.winbufnr(winnr))))
      if vim.tbl_contains(active_projs, tt) == false then
        active_projs[#active_projs + 1] = tt
      end
    end
    for _, project in ipairs(vim.tbl_keys(M.proj_buf)) do
      if vim.tbl_contains(active_projs, project) == false and vim.fn.buflisted(M.proj_buf[project]) == 1 then
        projs[#projs + 1] = project
      end
    end
    if #projs > 0 then
      vim.ui.select(projs, { prompt = 'append_one_proj_right_down', }, function(proj, _)
        if not proj then
          return
        end
        vim.cmd 'wincmd b'
        if B.file_exists(vim.api.nvim_buf_get_name(0)) then
          vim.cmd 'wincmd W'
        end
        vim.cmd 'wincmd s'
        vim.cmd('b' .. M.proj_buf[proj])
        vim.cmd 'e!'
      end)
    else
      print 'no append_one_proj_right_down'
    end
  end
end

function M.open_proj_in_new_tab(proj)
  if not proj then
    return
  end
  vim.cmd 'wincmd s'
  vim.cmd 'wincmd T'
  vim.cmd('b' .. M.proj_buf[proj])
  vim.cmd 'e!'
end

function M.append_one_proj_new_tab_no_dupl()
  if #vim.tbl_keys(M.proj_bufs) > 1 then
    local projs = {}
    local active_projs = {}
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
      local tt = B.rep_slash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(vim.fn.winbufnr(winid))))
      if vim.tbl_contains(active_projs, tt) == false then
        active_projs[#active_projs + 1] = tt
      end
    end
    for _, project in ipairs(vim.tbl_keys(M.proj_buf)) do
      if vim.tbl_contains(active_projs, project) == false and vim.fn.buflisted(M.proj_buf[project]) == 1 then
        projs[#projs + 1] = project
      end
    end
    if #projs > 0 then
      vim.ui.select(projs, { prompt = 'append_one_proj_new_tab_no_dupl', }, function(proj, _)
        M.open_proj_in_new_tab(proj)
      end)
    else
      print 'no append_one_proj_new_tab_no_dupl'
    end
  end
end

function M.simple_statusline_toggle()
  if M.simple_statusline then
    M.simple_statusline = nil
    vim.opt.showtabline = 2
    vim.opt.laststatus  = 3
    vim.opt.winbar      = ''
    vim.opt.statusline  = [[%f %h%m%r%=%<%-14.(%l,%c%V%) %P]]
  else
    M.simple_statusline = 1
    vim.opt.showtabline = 0
    vim.opt.laststatus  = 2
    vim.opt.winbar      = '%f'
    vim.opt.statusline  = '%{getcwd()}'
  end
end

function M.is_buf_deleted(buf)
  local file = B.rep_slash_lower(vim.api.nvim_buf_get_name(buf))
  if #file == 0 then
    return false
  end
  if not require 'plenary.path'.new(file):exists() then
    return false
  end
  if vim.fn.buflisted(buf) == 1 then
    return true
  end
  return false
end

function M.update_bufs_and_refresh_tabline()
  M.update_bufs()
  M.refresh_tabline()
end

function M.projectroot_titlestring(ev)
  pcall(vim.call, 'ProjectRootCD')
  local project = B.rep_backslash(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(ev.buf)))
  vim.opt.titlestring = string.format('%s %s', B.get_root_short(project), vim.fn.fnamemodify(vim.fn.bufname(ev.buf), ':t'))
end

vim.cmd [[
  hi tblsel guifg=#f8dfcf guibg=#777777 gui=bold
  hi tbltab guifg=#64e66e guibg=NONE gui=bold
  hi tblfil guifg=gray
]]

M.tabhiname = 'tbltab'
M.light = require 'nvim-web-devicons.icons-default'.icons_by_file_extension

M.color_table = {
  ['0'] = '0x5',
  ['1'] = '0x6',
  ['2'] = '0x7',
  ['3'] = '0x8',
  ['4'] = '0x9',
  ['5'] = '0xa',
  ['6'] = '0xb',
  ['7'] = '0xc',
  ['8'] = '0xd',
  ['9'] = '0xe',
  ['a'] = '0xf',
  ['b'] = '0x0',
  ['c'] = '0x1',
  ['d'] = '0x2',
  ['e'] = '0x3',
  ['f'] = '0x4',
}

function M.reverse_color(color)
  local new = '#'
  for i in string.gmatch(color, '%w') do
    new = new .. string.sub(M.color_table[i], 3, 3)
  end
  return new
end

function M.hi()
  for _, v in pairs(M.light) do
    if '' ~= v['icon'] then
      B.cmd('hi tbl%s guifg=%s guibg=%s gui=bold', v['name'], M.reverse_color(vim.fn.tolower(v['color'])), v['color'])
      B.cmd('hi tbl%s_ guifg=%s guibg=NONE gui=bold', v['name'], v['color'])
    end
  end
end

M.hi()

---------------------

vim.cmd [[
  function! SwitchBuffer(bufnr, mouseclicks, mousebutton, modifiers)
    call v:lua.SwitchBuffer(a:bufnr, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
  function! SwitchTab(tabnr, mouseclicks, mousebutton, modifiers)
    call v:lua.SwitchTab(a:tabnr, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
  function! SwitchTabNext(tabnr, mouseclicks, mousebutton, modifiers)
    call v:lua.SwitchTabNext(a:tabnr, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
  function! SwitchWindow(win_number, mouseclicks, mousebutton, modifiers)
    call v:lua.SwitchWindow(a:win_number, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
  function! SwitchNone(win_number, mouseclicks, mousebutton, modifiers)
  endfunction
]]

function SwitchBuffer(bufnr, mouseclicks, mousebutton, modifiers)
  if mousebutton == 'm' then -- and mouseclicks == 1 then
    vim.cmd('Bdelete! ' .. bufnr)
    M.update_bufs_and_refresh_tabline()
  elseif mousebutton == 'l' then -- and mouseclicks == 1 then
    if vim.fn.buflisted(vim.fn.bufnr()) ~= 0 then
      vim.cmd('b' .. bufnr)
      M.update_bufs_and_refresh_tabline()
    end
  elseif mousebutton == 'r' and mouseclicks == 1 then
    B.system_run('start silent', 'cmd /c start "" %s', vim.api.nvim_buf_get_name(bufnr))
  end
end

function SwitchTab(tabnr, mouseclicks, mousebutton, modifiers)
  if mousebutton == 'm' then -- and mouseclicks == 1 then
    pcall(vim.cmd, tabnr .. 'tabclose')
    M.update_bufs_and_refresh_tabline()
  elseif mousebutton == 'l' then -- and mouseclicks == 1 then
    vim.cmd(tabnr .. 'tabnext')
    pcall(vim.call, 'ProjectRootCD')
    M.update_bufs_and_refresh_tabline()
  elseif mousebutton == 'r' and mouseclicks == 1 then
  end
end

function SwitchTabNext(tabnr, mouseclicks, mousebutton, modifiers)
  if mousebutton == 'm' then -- and mouseclicks == 1 then
    pcall(vim.cmd, tabnr .. 'tabclose')
    M.update_bufs_and_refresh_tabline()
  elseif mousebutton == 'l' then -- and mouseclicks == 1 then
    local max_tabnr = vim.fn.tabpagenr '$'
    if tabnr < max_tabnr then
      tabnr = tabnr + 1
    else
      tabnr = 1
    end
    vim.cmd(tabnr .. 'tabnext')
    pcall(vim.call, 'ProjectRootCD')
    M.update_bufs_and_refresh_tabline()
  elseif mousebutton == 'r' and mouseclicks == 1 then
  end
end

-- function SwitchWindow(win_number, mouseclicks, mousebutton, modifiers)
--   if mousebutton == 'm' and mouseclicks == 1 then
--   elseif mousebutton == 'l' and mouseclicks == 1 then
--   elseif mousebutton == 'r' and mouseclicks == 1 then
--   end
-- end

---------------------

function M.is_buf_to_show(buf)
  local file = B.rep_slash_lower(vim.api.nvim_buf_get_name(buf))
  if #file == 0 then
    return false
  end
  if not require 'plenary.path'.new(file):exists() then
    return false
  end
  if vim.fn.buflisted(buf) == 0 then
    return false
  end
  if vim.api.nvim_buf_get_option(buf, 'buftype') == 'quickfix' then
    return false
  end
  return true
end

function M.update_bufs()
  M.cur_buf = ev and ev.buf or vim.fn.bufnr()
  local cur_proj = B.rep_slash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(M.cur_buf)))
  if not B.is(M.is_buf_to_show(M.cur_buf)) then
    M.cur_proj = cur_proj
    return
  end
  local proj_bufs = {}
  local proj_buf = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local file = B.rep_slash_lower(vim.api.nvim_buf_get_name(buf))
    if B.is(M.is_buf_to_show(buf)) then
      local proj = B.rep_slash_lower(vim.fn['ProjectRootGet'](file))
      if vim.tbl_contains(vim.tbl_keys(proj_bufs), proj) == false then
        proj_bufs[proj] = {}
      end
      proj_bufs[proj][#proj_bufs[proj] + 1] = buf
      proj_buf[proj] = buf
    end
  end
  if B.is(proj_bufs) and B.is(proj_buf) then
    M.proj_bufs = proj_bufs
    M.proj_buf = proj_buf
    M.cur_proj = cur_proj
  end
end

--------------

function M.get_buf_name(only_name)
  local ext = string.match(only_name, '%.([^.]+)$')
  if vim.tbl_contains(vim.tbl_keys(M.light), ext) == true and M.light[ext]['icon'] ~= '' then
    return vim.fn.fnamemodify(only_name, ':r') .. ' ' .. M.light[ext]['icon']
  end
  return only_name
end

function M.get_buf_to_show(bufs, cur_buf, tab_len)
  local index = B.index_of(bufs, cur_buf)
  if index == -1 then
    return {}
  end
  local columns = vim.opt.columns:get()
  local buf_len = columns - tab_len
  local newbufnrs = { bufs[index], }
  local ll = #tostring(cur_buf)
  local ss = vim.fn.strdisplaywidth(tostring(#bufs))
  buf_len = buf_len - vim.fn.strdisplaywidth(M.get_buf_name(B.get_only_name(vim.fn.bufname(cur_buf)))) - 4 - ll - ss
  if buf_len < 0 then
    return newbufnrs
  end
  local cnt1 = 1
  local cnt2 = 1
  for i = 2, #bufs do
    if i % 2 == 0 then
      local ii = index + cnt1
      if ii > #bufs then
        ii = index - cnt2
        local only_name = M.get_buf_name(B.get_only_name(vim.fn.bufname(bufs[ii])))
        buf_len = buf_len - vim.fn.strdisplaywidth(only_name) - 4
        -- B.print('#"%s": %d', only_name, vim.fn.strdisplaywidth(only_name))
        if #newbufnrs > 9 then
          buf_len = buf_len - 1
        end
        if buf_len < 0 then
          break
        end
        table.insert(newbufnrs, 1, bufs[ii])
        cnt2 = cnt2 + 1
      else
        local only_name = M.get_buf_name(B.get_only_name(vim.fn.bufname(bufs[ii])))
        buf_len = buf_len - vim.fn.strdisplaywidth(only_name) - 4
        if #newbufnrs > 9 then
          buf_len = buf_len - 1
        end
        if buf_len < 0 then
          break
        end
        table.insert(newbufnrs, bufs[ii])
        cnt1 = cnt1 + 1
      end
    else
      local ii = index - cnt2
      if ii < 1 then
        ii = index + cnt1
        local only_name = M.get_buf_name(B.get_only_name(vim.fn.bufname(bufs[ii])))
        buf_len = buf_len - vim.fn.strdisplaywidth(only_name) - 4
        if #newbufnrs > 9 then
          buf_len = buf_len - 1
        end
        if buf_len < 0 then
          break
        end
        table.insert(newbufnrs, bufs[ii])
        cnt1 = cnt1 + 1
      else
        local only_name = M.get_buf_name(B.get_only_name(vim.fn.bufname(bufs[ii])))
        buf_len = buf_len - vim.fn.strdisplaywidth(only_name) - 4
        if #newbufnrs > 9 then
          buf_len = buf_len - 1
        end
        if buf_len < 0 then
          break
        end
        table.insert(newbufnrs, 1, bufs[ii])
        cnt2 = cnt2 + 1
      end
    end
  end
  return newbufnrs
end

function M.one_tab()
  local tabs = ''
  local tab_len = 0
  local curtab = vim.fn.tabpagenr()
  local tabs_prefix = '%#tbltab#%' .. tostring(curtab) .. '@SwitchTabNext@'
  if vim.fn.tabpagenr '$' == 1 then
    tabs = tabs_prefix .. string.format(' %s ', vim.loop.cwd())
  else
    tabs = tabs_prefix .. string.format(' %d/%d %s ', curtab, vim.fn.tabpagenr '$', vim.loop.cwd())
  end
  tab_len = vim.fn.strdisplaywidth(tabs_prefix)
  return tabs, tab_len
end

-- 1. only cur tab
-- 2. multi tabs
M.tabs_way = 2

function M.get_tab_to_show()
  if M.tabs_way == 1 then
    return M.one_tab()
  elseif M.tabs_way == 2 then
    if vim.fn.tabpagenr '$' == 1 then
      return M.one_tab()
    else
      local tabs = ''
      local tab_len = 0
      local projs = {}
      local cur_tabnr = vim.fn.tabpagenr()
      local tab_max = vim.fn.tabpagenr '$'
      for tabnr = 1, tab_max do
        local proj = ''
        local temp_file = ''
        for _, bufnr in ipairs(vim.fn.tabpagebuflist(tabnr)) do
          temp_file = vim.api.nvim_buf_get_name(bufnr)
          local temp_proj = B.rep_slash_lower(vim.fn['ProjectRootGet'](temp_file))
          if temp_proj ~= '.' and vim.fn.isdirectory(temp_proj) == 1 and vim.tbl_contains(projs, temp_proj) == false then
            projs[#projs + 1] = temp_proj
            proj = temp_proj
            break
          end
        end
        if #proj == 0 then
          proj = temp_file
        end
        if cur_tabnr == tabnr then
          tabs = tabs .. string.format('%%#%s#%%', M.tabhiname)
        else
          tabs = tabs .. '%#tblfil#%'
        end
        tabs = tabs .. tostring(tabnr) .. '@SwitchTab@'
        local temp = ''
        if cur_tabnr == tabnr then
          temp = string.format(' %d/%d %s ', tabnr, tab_max, B.get_root_short(proj))
        else
          temp = string.format(' %d %s ', tabnr, B.get_root_short(proj))
        end
        tab_len = tab_len + vim.fn.strdisplaywidth(temp)
        tabs = tabs .. temp
      end
      return tabs, tab_len
    end
  end
end

M.bufs_to_show_last = {}
M.cur_buf_last = 1

function M.one_buf(buf_index_first, index, cur_buf, buf)
  local bufs = {}
  local only_name = B.get_only_name(vim.fn.bufname(buf))
  local icon = ''
  local hiname = 'tblsel'
  local only_name_no_ext = vim.fn.fnamemodify(only_name, ':r')
  local ext = string.match(only_name, '%.([^.]+)$')
  if vim.tbl_contains(vim.tbl_keys(M.light), ext) == true and M.light[ext]['icon'] ~= '' then
    icon = M.light[ext]['icon']
    hiname = 'tbl' .. M.light[ext]['name']
  end
  local name = only_name
  if cur_buf == buf then
    M.tabhiname = hiname
    if B.is(icon) then
      icon = ' ' .. icon
      name = only_name_no_ext
    end
    if M.proj_bufs[M.cur_proj] then
      bufs[#bufs + 1] = string.format('%%#%s#%%%d@SwitchBuffer@ %d/%d %s%s ', hiname, buf, buf_index_first + index - 1, #M.proj_bufs[M.cur_proj], name, icon)
    else
      bufs[#bufs + 1] = string.format('%%#%s#%%%d@SwitchBuffer@ %d/%d %s%s ', hiname, buf, buf_index_first + index - 1, 1, name, icon)
    end
  else
    if B.is(icon) then
      icon = string.format(' %%#%s_#%s%%#tblfil#', hiname, icon)
      name = only_name_no_ext
    end
    bufs[#bufs + 1] = string.format('%%#tblfil#%%%d@SwitchBuffer@ %d %s%s ', buf, buf_index_first + index - 1, name, icon)
  end
  return vim.fn.join(bufs, '')
end

function M.get_buf_content(tab_len)
  local bufs_to_show = {}
  local buf_index_first = 1
  local cur_buf = M.cur_buf
  if M.proj_bufs[M.cur_proj] then
    bufs_to_show = M.get_buf_to_show(M.proj_bufs[M.cur_proj], cur_buf, tab_len)
    if #bufs_to_show == 0 then
      if #M.bufs_to_show_last > 0 then
        bufs_to_show = M.bufs_to_show_last
        cur_buf = M.cur_buf_last
      else
        bufs_to_show = M.proj_bufs[M.cur_proj]
      end
    else
      M.bufs_to_show_last = bufs_to_show
      M.cur_buf_last = cur_buf
    end
    buf_index_first = B.index_of(M.proj_bufs[M.cur_proj], bufs_to_show[1])
  else
    return M.one_buf(buf_index_first, 1, cur_buf, vim.fn.bufnr())
  end
  local res = ''
  for index, buf in ipairs(bufs_to_show) do
    res = res .. M.one_buf(buf_index_first, index, cur_buf, buf)
  end
  return res
end

function M.refresh_tabline()
  M.cur_buf = ev and ev.buf or vim.fn.bufnr()
  local tabs_to_show, tab_len = M.get_tab_to_show()
  vim.opt.tabline = M.get_buf_content(tab_len) .. '%#tblfil#%1@SwitchNone@%=%<%#tblfil#' .. tabs_to_show
end

function M.toggle_tabs_way()
  M.tabs_way = M.tabs_way + 1
  if M.tabs_way > 2 then
    M.tabs_way = 1
  end
  if M.tabs_way == 1 then
    B.notify_info 'only cur tab'
  elseif M.tabs_way == 2 then
    B.notify_info 'multi tabs'
  end
  M.update_bufs_and_refresh_tabline()
end

B.aucmd('BufEnter', 'my.tabline.BufEnter', {
  callback = function()
    M.update_bufs_and_refresh_tabline()
  end,
})

B.aucmd({ 'WinResized', }, 'my.tabline.WinResized', {
  callback = function()
    M.update_bufs_and_refresh_tabline()
  end,
})

B.aucmd({ 'DirChanged', 'TabEnter', }, 'my.tabline.DirChanged', {
  callback = function()
    M.update_bufs_and_refresh_tabline()
    pcall(vim.cmd, 'ProjectRootCD')
  end,
})

B.aucmd('BufEnter', 'my.tabline.BufEnter-vim-projectroot', {
  callback = function(ev)
    M.projectroot_titlestring(ev)
  end,
})

return M
