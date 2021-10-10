local install_path = ("%s/site/pack/packer-lib/opt/packer.nvim"):format(vim.fn.stdpath "data")

local function install_packer()
    vim.fn.termopen(("git clone https://github.com/wbthomason/packer.nvim %q"):format(install_path))
end

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    install_packer()
end

vim.cmd [[packadd packer.nvim]]

function _G.packer_upgrade()
    vim.fn.delete(install_path, "rf")
    install_packer()
end

vim.cmd [[command! PackerUpgrade :call v:lua.packer_upgrade()]]

return require("packer").startup(function(use, use_rocks)
    -- tpope
    use {
        "tpope/vim-repeat",
        "tpope/vim-commentary",
        "tpope/vim-surround",
        "tpope/vim-fugitive",
        {
            "tpope/vim-sleuth",
            setup = function()
                vim.g.sleuth_automatic = 0
            end,
        },
        {
            "tpope/vim-dispatch",
            requires = { "radenling/vim-dispatch-neovim" },
        },
    }

    -- test & debugging
    use {
        {
            "puremourning/vimspector",
            setup = function()
                vim.fn.sign_define("vimspectorBP", { text = " ●", texthl = "VimspectorBreakpoint" })
                vim.fn.sign_define("vimspectorBPCond", { text = " ●", texthl = "VimspectorBreakpointCond" })
                vim.fn.sign_define("vimspectorBPDisabled", { text = " ●", texthl = "VimspectorBreakpointDisabled" })
                vim.fn.sign_define(
                    "vimspectorPC",
                    { text = "▶", texthl = "VimspectorProgramCounter", linehl = "VimspectorProgramCounterLine" }
                )
                vim.fn.sign_define("vimspectorPCBP", {
                    text = "●▶",
                    texthl = "VimspectorProgramCounterBreakpoint",
                    linehl = "VimspectorProgramCounterLine",
                })
            end,
            ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        },
        {
            "janko/vim-test",
            config = function()
                require("wb.vim-test").setup()
            end,
        },
    }

    use {
        "kkoomen/vim-doge",
        cmd = { "DogeGenerate" },
        run = function()
            vim.fn["doge#install"]()
        end,
        setup = function()
            vim.g.doge_enable_mappings = 0
            vim.g.doge_comment_jump_modes = { "n" }
        end,
    }

    -- nvim extensions & decorators
    use {
        "simnalamburt/vim-mundo",
        "airblade/vim-rooter",
        "hrsh7th/vim-vsnip",
        "hrsh7th/vim-vsnip-integ",
        "Raimondi/delimitMate",
        "wellle/tmux-complete.vim",
        "psliwka/vim-smoothie",
        {
            "t9md/vim-choosewin",
            config = function()
                vim.api.nvim_set_keymap("n", "-", "<Plug>(choosewin)", {})
            end,
        },
        {
            "ms-jpq/coq_nvim",
            requires = {
                { "ms-jpq/coq.artifacts", branch = "artifacts" },
                { "ms-jpq/coq.thirdparty", branch = "3p" },
            },
            branch = "coq",
            setup = function()
                vim.g.coq_settings = {
                    auto_start = true,
                    ["display.pum.fast_close"] = false,
                }
            end,
            config = function()
                local sources = {
                    { src = "bc", short_name = "MATH", precision = 6 },
                    { src = "repl", unsafe = { "rm", "sudo", "mv", "cp" } },
                }
                if vim.fn.executable "figlet" == 1 then
                    table.insert(sources, { src = "figlet" })
                end
                if vim.fn.executable "cowsay" == 1 then
                    table.insert(sources, { src = "cow" })
                end
                require "coq_3p"(sources)
                require "wb.coq_3p.uuid"
            end,
        },
        {
            "rhysd/clever-f.vim",
            setup = function()
                vim.g.clever_f_across_no_line = 1
            end,
        },
        {
            "junegunn/vim-peekaboo",
            setup = function()
                vim.g.peekaboo_compact = 0
            end,
        },
        {
            "kyazdani42/nvim-tree.lua",
            setup = function()
                vim.g.nvim_tree_git_hl = 1
                vim.g.nvim_tree_add_trailing = 1
            end,
            after = "nvim-lsp-installer",
            config = function()
                require("wb.nvim-tree").setup()
            end,
        },
        {
            "NTBBloodbath/galaxyline.nvim",
            branch = "main",
            config = function()
                require("wb.galaxyline").setup()
            end,
        },
        {
            "szw/vim-maximizer",
            config = function()
                vim.api.nvim_set_keymap("n", "<C-w>z", "<cmd>MaximizerToggle!<CR>", { silent = true, noremap = false })
            end,
        },
        {
            "akinsho/toggleterm.nvim",
            config = function()
                require("toggleterm").setup {
                    open_mapping = [[<C-t>]],
                }
            end,
        },
        {
            "haya14busa/incsearch.vim",
            config = function()
                require("wb.incsearch").setup()
            end,
        },
    }

    -- UI & Syntax
    use {
        "editorconfig/editorconfig-vim",
        {
            "rcarriga/nvim-notify",
            config = function()
                local cool_notify = require "notify"
                local oem_notify = vim.notify
                vim.notify = function(...)
                    cool_notify(...)
                    oem_notify(...) -- nobody puts :messages in a corner
                end
            end,
        },
        {
            "sheerun/vim-polyglot",
            setup = function()
                vim.g.polyglot_disabled = { "autoindent", "sensible" }
            end,
        },
        "christianchiarulli/nvcode-color-schemes.vim",
        "kyazdani42/nvim-web-devicons",
        {
            "lukas-reineke/indent-blankline.nvim",
            setup = function()
                vim.g.indent_blankline_use_treesitter = true
                vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
                vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
                vim.g.indent_blankline_char = "▏"
                vim.cmd [[set colorcolumn=99999]]
            end,
        },
        {
            "norcalli/nvim-colorizer.lua",
            config = function()
                require("wb.nvim-colorizer").setup()
            end,
        },
    }

    -- Treesitter
    if vim.fn.has "unix" == 1 then
        use {
            "nvim-treesitter/playground",
            "p00f/nvim-ts-rainbow",
            "JoosepAlviste/nvim-ts-context-commentstring",
            "nvim-treesitter/nvim-treesitter-textobjects",
            {
                "nvim-treesitter/nvim-treesitter",
                run = ":TSUpdate",
                config = function()
                    require("wb.nvim-treesitter").setup()
                end,
            },
            {
                "windwp/nvim-ts-autotag",
                ft = { "html", "javascript", "javascriptreact", "typescriptreact", "svelte", "vue" },
            },
        }
    end

    -- LSP
    use {
        {
            vim.trim(vim.fn.system "hostname") == "Williams-MacBook-Air.local"
                    and "~/dev/github/nvim-lsp-installer"
                or "williamboman/nvim-lsp-installer",
            requires = {
                "neovim/nvim-lspconfig",
            },
            after = "coq_nvim",
            config = function()
                require("wb.lsp").setup()
            end,
        },
        "folke/lua-dev.nvim",
        -- { "mfussenegger/nvim-jdtls", ft = { "java" } },
        {
            "onsails/lspkind-nvim",
            config = function()
                require("lspkind").init()
            end,
        },
    }

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzy-native.nvim",
        },
        config = function()
            require("wb.telescope").setup()
        end,
    }

    -- git
    use {
        "rhysd/git-messenger.vim",
        "rhysd/committia.vim",
        {
            "lewis6991/gitsigns.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
            },
            config = function()
                require("wb.gitsigns").setup()
            end,
        },
    }

    -- Formatting/code style
    use {
        "mhartington/formatter.nvim",
        config = function()
            require("wb.formatter").setup()
        end,
    }

    -- Misc
    use { "tweekmonster/startuptime.vim", cmd = { "StartupTime" } }
    if vim.fn.has "win32" ~= 1 then
        use "wakatime/vim-wakatime"
    end
end)
