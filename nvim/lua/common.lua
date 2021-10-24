local M = {}
local home = os.getenv("HOME")
local path_sep = M.is_windows and '\\' or '/'
local os_name = vim.loop.os_uname().sysname

function M:init_variables()
    self.is_mac = os_name == 'Darwin'
    self.is_linux = os_name == 'Linux'
    self.is_remote = os.getenv('DISPLAY') == nil
    -- self.is_windows = os_name == 'Windows'
    -- self.vim_path    = vim.fn.stdpath('config')
    -- self.cache_dir   = home .. path_sep..'.cache'..path_sep..'nvim'..path_sep
    -- self.modules_dir = self.vim_path .. path_sep..'modules'
    -- self.path_sep = path_sep
    -- self.home = home
    -- self.data_dir = string.format('%s/site/',vim.fn.stdpath('data'))
end

M:init_variables()

M.bind_key = function(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

M.g_opt = function(k, v) vim.api.nvim_set_option(k, v) end

M.b_opt = function(k, v)
    vim.api.nvim_set_option(k, v)
    vim.api.nvim_buf_set_option(0, k, v)
end

M.w_opt = function(k, v)
    vim.api.nvim_set_option(k, v)
    vim.api.nvim_win_set_option(0, k, v)
end

M.add_autocmd_groups = function(defs)
    for group_name, definition in pairs(defs) do
        vim.api.nvim_command('augroup ' .. group_name)
        vim.api.nvim_command('autocmd!')
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten {'autocmd', def}, ' ')
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command('augroup END')
    end
end

M.set_var = function(k, v) vim.api.nvim_set_var(k, v) end
M.pprint = function(v) print(vim.inspect(v)) end

return M
