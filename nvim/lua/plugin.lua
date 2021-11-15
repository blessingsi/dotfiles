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
        use {
            'preservim/nerdtree',
            requires = {
                {'Xuyuanp/nerdtree-git-plugin'}, {'unkiwii/vim-nerdtree-sync'}
            },
            config = function()
                require('common').bind_key('n', '<F4>', ':NERDTreeToggle<CR>')
            end
        }

        use {'fatih/molokai'}
        use {
            'glepnir/galaxyline.nvim',
            branch = 'main',
            config = function() require('plugins.statusline') end,
            requires = {'kyazdani42/nvim-web-devicons'}
        }
        --------------------dev------------------------------------
        use {
                'nvim-treesitter/nvim-treesitter',
                branch = '0.5-compat',
                requires =  'nvim-treesitter/nvim-treesitter-textobjects',
                run = ':TSUpdate',
                config = function() require('plugins.treesitter') end,
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
            'preservim/tagbar',
            config = function()
                require('common').bind_key('n', '<leader>t', ':TagbarToggle<CR>')
            end
        }
        use {'liuchengxu/vista.vim'}
        use {'tpope/vim-commentary'}
        use {'editorconfig/editorconfig-vim'}
        use {
            'lewis6991/gitsigns.nvim',
            requires = {'nvim-lua/plenary.nvim'},
            config = function() require('gitsigns').setup() end
        }

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
