vim.cmd([[set t_8f=^[[38;2;%lu;%lu;%lum]])
vim.cmd([[set t_8b=^[[48;2;%lu;%lu;%lum]])
vim.cmd([[set cmdheight=2]])
vim.cmd([[set termguicolors]])
vim.cmd([[set hidden]])
vim.cmd([[set number]])
vim.cmd([[set relativenumber]])
vim.cmd([[set mouse=a]])
vim.cmd([[set inccommand=split]])
vim.cmd([[set completeopt=menuone,noinsert,noselect]])
vim.cmd([[set encoding=UTF-8]])
vim.cmd([[set autoindent expandtab tabstop=2 shiftwidth=2]])
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
-- dracula-pro theme
vim.cmd([[
packadd! dracula_pro
syntax enable
let g:dracula_colorterm = 0
colorscheme dracula_pro
]])

vim.g.mapleader = ' '
vim.keymap.set('n', '<c-p>', ':Files<cr>')

-- nerdtree config
vim.keymap.set('n', '<Leader>n', ':NvimTreeFocus<CR>')
vim.keymap.set('n', '<C-n>', ':NvimTreeCollapse<CR>')
vim.keymap.set('n', '<C-t>', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<C-f>', ':NvimTreeFindFile<CR>')
-- -- ignore node_modules
vim.cmd 'let g:NERDTreeIgnore = ["^node_modules$"]'
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- nvim config
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    renderer = {
        group_empty = true
    },
    filters = {
        dotfiles = true
    }
})

-- lualine config
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'dracula',
        section_separators = {
            left = '',
            right = ''
        },
        component_separators = {
            left = '',
            right = ''
        },
        disabled_filetypes = {}
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch'},
        lualine_c = {{
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            path = 0 -- 0 = just filename, 1 = relative path, 2 = absolute path
        }},
        lualine_x = {{
            'diagnostics',
            sources = {"nvim_diagnostic"},
            symbols = {
                error = ' ',
                warn = ' ',
                info = ' ',
                hint = ' '
            }
        }, 'encoding', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
        }},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {'fugitive'}
}

require('telescope').setup()
vim.keymap.set('n', '<Leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<Leader>fg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<Leader>fb', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<Leader>fh', '<cmd>Telescope help_tags<cr>')
local bufopts = {
    noremap = true,
    silent = true,
    buffer = bufnr
}
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

-- Formating with neoformat
vim.cmd 'let g:neoformat_try_node_exe = 1'

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"javascript", "javascriptreact", "typescript", "typescriptreact"},
    callback = function()
        vim.cmd("Neoformat")
    end,
    group = autogroup_eslint_lsp
})

vim.cmd [[cabbrev w execute "Format sync" <bar> w]]

vim.diagnostic.config({
    virtual_text = false
})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- git

require('gitsigns').setup {
    signs = {
        add = {
            text = '│'
        },
        change = {
            text = '│'
        },
        delete = {
            text = '_'
        },
        topdelete = {
            text = '‾'
        },
        changedelete = {
            text = '~'
        },
        untracked = {
            text = '┆'
        }
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        interval = 1000,
        follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
    yadm = {
        enable = false
    }
}

require('git').setup({
    default_mappings = true, -- NOTE: `quit_blame` and `blame_commit` are still merged to the keymaps even if `default_mappings = false`

    keymaps = {
        -- Open blame window
        blame = "<Leader>gb",
        -- Close blame window
        quit_blame = "q",
        -- Open blame commit
        blame_commit = "<CR>",
        -- Open file/folder in git repository
        browse = "<Leader>go",
        -- Open pull request of the current branch
        open_pull_request = "<Leader>gp",
        -- Create a pull request with the target branch is set in the `target_branch` option
        create_pull_request = "<Leader>gn",
        -- Opens a new diff that compares against the current index
        diff = "<Leader>gd",
        -- Close git diff
        diff_close = "<Leader>gD",
        -- Revert to the specific commit
        revert = "<Leader>gr",
        -- Revert the current file to the specific commit
        revert_file = "<Leader>gR"
    },
    -- Default target branch when create a pull request
    target_branch = "master"
})
