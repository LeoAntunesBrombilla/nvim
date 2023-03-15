vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/plenary.nvim'}}
    }
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {'kyazdani42/nvim-web-devicons'}
    }
    use 'Xuyuanp/nerdtree-git-plugin'
    use 'tiagofumo/vim-nerdtree-syntax-highlight'
    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
            opt = true
        }
    }
    use {"williamboman/nvim-lsp-installer", "neovim/nvim-lspconfig"}
    use "lukas-reineke/lsp-format.nvim"
    use 'onsails/lspkind-nvim'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use 'L3MON4D3/LuaSnip'
    -- use 'rafamadriz/friendly-snippets'
    -- use 'ray-x/lsp_signature.nvim'
    -- use 'scrooloose/nerdcommenter'
    use "jose-elias-alvarez/null-ls.nvim"
    use "jose-elias-alvarez/nvim-lsp-ts-utils"
    use 'MunifTanjim/prettier.nvim'
    use 'jiangmiao/auto-pairs'
    use 'sbdchd/neoformat'

    use "f-person/git-blame.nvim"
    use({
        "glepnir/lspsaga.nvim",
        branch = "main"
    })
    use {'lewis6991/gitsigns.nvim' -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
    }
    use {'dinhhuy258/git.nvim'}
end)

