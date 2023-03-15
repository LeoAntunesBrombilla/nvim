-- -- Setup lsp TS
-- nvim_lsp.tsserver.setup { on_attach = require("lsp-format").on_attach }
-- require "lsp_signature".setup()
-- -- vim.o.completeopt = 'menuone,noselect'
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
local cmp = require 'cmp'
local lspkind = require('lspkind')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        })
    }),
    sources = cmp.config.sources({{
        name = 'nvim_lsp'
    }, {
        name = 'buffer'
    }}),
    formatting = {
        format = lspkind.cmp_format({
            maxwidth = 50
        })
    }
})

vim.cmd [[
    set completeopt=menuone,noinsert,noselect
    highlight! default link CmpItemKind CmpItemMenuDefault
  ]]

local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then
    return
end

local protocol = require('vim.lsp.protocol')

local augroup_format = vim.api.nvim_create_augroup("Format", {
    clear = true
})
local enable_format_on_save = function(_, bufnr)
    vim.api.nvim_clear_autocmds({
        group = augroup_format,
        buffer = bufnr
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_format,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({
                bufnr = bufnr
            })
        end
    })
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    -- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = {
        noremap = true,
        silent = true
    }

end

protocol.CompletionItemKind = {'', -- Text
'', -- Method
'', -- Function
'', -- Constructor
'', -- Field
'', -- Variable
'', -- Class
'ﰮ', -- Interface
'', -- Module
'', -- Property
'', -- Unit
'', -- Value
'', -- Enum
'', -- Keyword
'﬌', -- Snippet
'', -- Color
'', -- File
'', -- Reference
'', -- Folder
'', -- EnumMember
'', -- Constant
'', -- Struct
'', -- Event
'ﬦ', -- Operator
'' -- TypeParameter
}

-- Set up completion using nvim_cmp with LSP source
local capabilities = require('cmp_nvim_lsp').default_capabilities()

nvim_lsp.flow.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

nvim_lsp.tsserver.setup {
    on_attach = on_attach,
    filetypes = {"typescript", "typescriptreact", "typescript.tsx"},
    cmd = {"typescript-language-server", "--stdio"},
    capabilities = capabilities
}

-- Setup lsp GO
nvim_lsp.gopls.setup {
    cmd = {'gopls'},
    -- for postfix snippets and analyzers
    capabilities = capabilities,
    settings = {
        gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
                unusedparams = true,
                shadow = true
            },
            staticcheck = true
        }
    },
    on_attach = on_attach
}

nvim_lsp.sourcekit.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

nvim_lsp.lua_ls.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        enable_format_on_save(client, bufnr)
    end,
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'}
            },

            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
            }
        }
    }
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    update_in_insert = false,
    virtual_text = {
        spacing = 4,
        prefix = "●"
    },
    severity_sort = true
})

-- Diagnostic symbols in the sign column (gutter)
local signs = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " "
}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {
        text = icon,
        texthl = hl,
        numhl = ""
    })
end

vim.diagnostic.config({
    virtual_text = {
        prefix = '●'
    },
    update_in_insert = true,
    float = {
        source = "always" -- Or "if_many"
    }
})

-- Treesitter move to another file when have time 

require'nvim-treesitter.configs'.setup {
    ensure_installed = {"typescript", "go", "graphql", "javascript", "jsdoc"},
    highlight = {
        enable = true
    },
    indent = {
        enable = true
    },
    autotag = {
        enable = true
    }
}

-- lsp saga
local saga = require 'lspsaga'
saga.setup({
    ui = {
        winblend = 10,
        border = 'rounded',
        colors = {
            normal_bg = '#002b36'
        }
    }
})

local diagnostic = require("lspsaga.diagnostic")
local opts = {
    noremap = true,
    silent = true
}
vim.keymap.set('n', '<C-j>', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
vim.keymap.set('n', 'gl', '<Cmd>Lspsaga show_diagnostic<CR>', opts)
vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', opts)

require("lsp-format").setup {}
local prettier = {
    formatCommand = [[prettier --stdin-filepath ${INPUT} ${--tab-width:tab_width}]],
    formatStdin = true
}
require("nvim-lsp-installer").setup {
    settings = {
        languages = {
            typescript = {prettier, {
                tab_width = 2
            }},
            javascript = {prettier}
        }
    }
}

-- null and prettier

local prettier = require("prettier")

prettier.setup({
  bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
    "go"
  },
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "null-ls"
        end,
        bufnr = bufnr
    })
end

local null_ls = require("null-ls")

null_ls.setup {
    sources = {null_ls.builtins.formatting.prettierd, null_ls.builtins.diagnostics.eslint_d.with({
        diagnostics_format = '[eslint] #{m}\n(#{c})'
    }), null_ls.builtins.diagnostics.fish},
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
                group = augroup,
                buffer = bufnr
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    lsp_formatting(bufnr)
                end
            })
        end
    end
}

vim.api.nvim_create_user_command('DisableLspFormatting', function()
    vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = 0
    })
end, {
    nargs = 0
})
