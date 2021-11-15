local helper = require("common")

-------- vars ------------------------------------------------------------------
local g = vim.g
g.mapleader = ';'

g.loaded_python_provider = 0
g.python3_host_prog = '~/.venvs/neovim/bin/python'

if helper.is_linux and helper.is_remote then
    g.clipboard = {
        copy = {['+'] = 'lemonade copy', ['*'] = 'lemonade copy'},
        paste = {['+'] = 'lemonade paste', ['*'] = 'lemonade paste'},
        name = 'lemonade'
    }
end

-------- vars end --------------------------------------------------------------

-------- options ---------------------------------------------------------------
helper.g_opt('completeopt', 'menuone,noinsert,noselect')
helper.g_opt('hidden', true)
helper.g_opt('ignorecase', true)
helper.g_opt('joinspaces', false)
helper.g_opt('scrolloff', 4)
helper.g_opt('shiftround', true)
helper.g_opt('sidescrolloff', 8)
helper.g_opt('smartcase', true)
helper.g_opt('termguicolors', true)
helper.g_opt('wildmenu', true)
helper.g_opt('fileencodings', 'ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1')

helper.b_opt('tabstop', 4)
helper.b_opt('shiftwidth', 4)
helper.b_opt('expandtab', true)

helper.w_opt('list', true)
helper.w_opt('number', true)

-------- options end -----------------------------------------------------------

-------- key bindings-----------------------------------------------------------
helper.bind_key('v', '<leader>y', '"+y')
helper.bind_key('n', '<leader>y', '"+yy')
helper.bind_key('n', '<leader>ya', 'gg"+yG')
helper.bind_key('n', '\\', ';')
helper.bind_key('n', '<leader>ev', '<cmd>vsp $MYVIMRC<CR>')
helper.bind_key('i', '<C-u>', '<C-g>u<C-u>') -- Make <C-u> undo-friendly
helper.bind_key('i', '<C-w>', '<C-g>u<C-w>') -- Make <C-w> undo-friendly
helper.bind_key('n', '<leader>l', '<cmd>noh<CR>') -- Clear highlights
helper.bind_key('n', '<C-l>', '<C-w>l')
helper.bind_key('n', '<C-h>', '<C-w>h')
helper.bind_key('n', '<leader>o', 'm`o<Esc>``')
helper.bind_key('n', '<leader>O', 'm`O<Esc>``')
helper.bind_key('n', '<C-p>',
                vim.bo[0].buftype == 'quickfix' and "<C-p>" or ':Files<CR>')

helper.bind_key('i', '<C-f>', '<right>')
helper.bind_key('i', '<C-b>', '<left>')
-------- key bindings end ------------------------------------------------------

-------- autocmds --------------------------------------------------------------
groups = {basic = {{"BufWritePost", "$MYVIMRC", "luafile $MYVIMRC"}}}
helper.add_autocmd_groups(groups)
-------- autocmds end-----------------------------------------------------------

require('plugin')
vim.cmd('colorscheme molokai')
