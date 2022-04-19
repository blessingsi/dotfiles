local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        'git', 'clone', '--depth', '1',
        'https://github.com/wbthomason/packer.nvim', install_path
    })
end

helper = require('common')
helper.add_autocmd_groups({
    packer = {{"BufWritePost", "plugin.lua", "source <afile> | PackerCompile"}}
})

return require('packer').startup({
    function()
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        --------------------basic----------------------------------
        use {'tpope/vim-surround'}
        use {'junegunn/fzf', run = function() vim.fn['fzf#install()'](0) end}
        use {'junegunn/fzf.vim'}
        use {'fatih/molokai'}
        use {
            'kyazdani42/nvim-tree.lua',
            requires = {'kyazdani42/nvim-web-devicons'},
            config = function()
                require'nvim-tree'.setup {}
                require('common').bind_key('n', '<F4>', ':NvimTreeToggle<CR>')
            end
        }
        use {
            'nvim-lualine/lualine.nvim',
            config = function()
                require('lualine').setup {
                    options = {
                        theme = 'material',
                        section_separators = {left = ' ', right = ' '}
                    }

                }
            end,
            requires = {'kyazdani42/nvim-web-devicons', opt = true}
        }
        --------------------dev------------------------------------
        use {
            'nvim-treesitter/nvim-treesitter',
            requires = 'nvim-treesitter/nvim-treesitter-textobjects',
            run = ':TSUpdate',
            config = function() require('plugins.treesitter') end
        }

        use {
            'neovim/nvim-lspconfig',
            config = function() require('plugins.lsp_config') end,
            requires = {'ray-x/lsp_signature.nvim'}
        }
        use {
            "hrsh7th/nvim-cmp",
            requires = {
                "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-path", "hrsh7th/cmp-vsnip", "hrsh7th/cmp-nvim-lua"
            },
            config = function() require('plugins.cmp') end
        }
        use {'hrsh7th/vim-vsnip'}
        use {'rafamadriz/friendly-snippets'}
        use {
            'liuchengxu/vista.vim',
            config = function()
                vim.g.vista_echo_cursor = 0
                vim.g.vista_executive_for = {go = 'nvim_lsp', rust = 'nvim_lsp'}
                require('common').bind_key('n', '<leader>t', ':Vista!!<CR>')
                require('common').bind_key('n', '<leader><leader>t',
                                           ':Vista finder<CR>')
            end
        }
        use {'tpope/vim-commentary'}
        use {'editorconfig/editorconfig-vim'}
        use {
            'lewis6991/gitsigns.nvim',
            requires = {'nvim-lua/plenary.nvim'},
            config = function()
                require('gitsigns').setup({
                    on_attach = function(bufnr)

                        -- Navigation
                        require('common').bind_key('n', ']c',
                                                   "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'",
                                                   {expr = true})
                        require('common').bind_key('n', '[c',
                                                   "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'",
                                                   {expr = true})
                        require('common').bind_key('n', '<leader>hs',
                                                   ':Gitsigns stage_hunk<CR>')
                        require('common').bind_key('v', '<leader>hs',
                                                   ':Gitsigns stage_hunk<CR>')
                        require('common').bind_key('n', '<leader>hr',
                                                   ':Gitsigns reset_hunk<CR>')
                        require('common').bind_key('v', '<leader>hr',
                                                   ':Gitsigns reset_hunk<CR>')
                        require('common').bind_key('n', '<leader>hS',
                                                   '<cmd>Gitsigns stage_buffer<CR>')
                        require('common').bind_key('n', '<leader>hu',
                                                   '<cmd>Gitsigns undo_stage_hunk<CR>')
                        require('common').bind_key('n', '<leader>hR',
                                                   '<cmd>Gitsigns reset_buffer<CR>')
                        require('common').bind_key('n', '<leader>hp',
                                                   '<cmd>Gitsigns preview_hunk<CR>')
                        require('common').bind_key('n', '<leader>hb',
                                                   '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
                        require('common').bind_key('n', '<leader>tb',
                                                   '<cmd>Gitsigns toggle_current_line_blame<CR>')
                        require('common').bind_key('n', '<leader>hd',
                                                   '<cmd>Gitsigns diffthis<CR>')
                        require('common').bind_key('n', '<leader>hD',
                                                   '<cmd>lua require"gitsigns".diffthis("~")<CR>')
                        require('common').bind_key('n', '<leader>td',
                                                   '<cmd>Gitsigns toggle_deleted<CR>')
                        require('common').bind_key('o', 'ih',
                                                   ':<C-U>Gitsigns select_hunk<CR>')
                        require('common').bind_key('x', 'ih',
                                                   ':<C-U>Gitsigns select_hunk<CR>')
                    end
                })
            end
        }

        use {'fatih/vim-go'}

        use {
            'ojroques/nvim-lspfuzzy',
            config = function()
                require'lspfuzzy'.setup {
                    methods = {
                        'textDocument/documentSymbol', 'workspace/symbol'
                    }
                }
            end
        }
        use {
            'andrejlevkovitch/vim-lua-format',
            config = function()
                helper.add_autocmd_groups({
                    luafmt = {{'BufWrite', '*.lua', ':call LuaFormat()'}}
                })
            end
        }

        if packer_bootstrap then require('packer').sync() end
    end,

    config = {
        git = {clone_timeout = 180},
        display = {open_fn = require('packer.util').float}
    }
})
