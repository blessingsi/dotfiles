local map = function(type, key, value)
    vim.api.nvim_buf_set_keymap(0, type, key, value,
                                {noremap = true, silent = true});
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
local custom_attach = function(client)
    print("LSP started.");
    require'lsp_signature'.on_attach()

    map('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
    map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    map('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    map('n', 'gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
    map('n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
    map('n', '<leader>af', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    map('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>')
    map('n', 'gI', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
    map('n', 'go', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
    map('n', '<F2>', '<cmd>lua vim.diagnostic.goto_next()<CR>')
    map('n', '<F3>', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
end

local lsp = require 'lspconfig'

local defaultServers = {"ccls"}
for _, s in ipairs(defaultServers) do lsp[s].setup {on_attach = custom_attach, capabilities = capabilities} end

lsp.pyright.setup {
    on_attach = custom_attach,
    capabilities = capabilities,
    settings = {python = {analysis = {autoImportCompletions = true}}}
}

lsp.rust_analyzer.setup({
    on_attach=custom_attach,
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})

lsp.jsonls.setup {
    on_attach = function(client)
        custom_attach(client);
        map('n', 'gf',
            '<cmd>lua vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$")+1,0})<CR>')
    end
}

lsp.gopls.setup {
    on_attach = custom_attach,
    capabilities = capabilities,
    settings = {gopls = {analyses = {unusedparams = true}, staticcheck = true}}
}

-- vim.lsp.set_log_level("debug")
