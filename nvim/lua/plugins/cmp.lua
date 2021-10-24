local cmp = require 'cmp'
cmp.setup {
    snippet = {expand = function(args) vim.fn['vsnip#anonymous'](args.body) end},
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        }),
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end
    },

    sources = {
        {name = 'vsnip'}, {name = 'nvim_lsp'}, {name = 'path'},
        {name = 'buffer'}, {name = 'nvim_lua'}
    },

    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                -- luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]"
            })[entry.source.name]
            return vim_item
        end
    }
}
