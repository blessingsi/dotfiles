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
            config = function() require('gitsigns').setup() end
        }

        use {'mfussenegger/nvim-dap'}

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
