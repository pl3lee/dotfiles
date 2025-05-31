return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            {
                "mason-org/mason.nvim",
            },
            {
                "williamboman/mason-lspconfig.nvim",
            },
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "gopls",
                    "ts_ls",
                    "tailwindcss",
                    "biome",
                    "pyright",
                    "marksman",
                },
                automatic_enable = {
                    exclude = {
                        "lua_ls",
                        "gopls",
                        "ts_ls",
                        "tailwindcss",
                        "biome",
                        "pyright",
                        "marksman",
                    },
                },
            })

            -- Define LSPs here
            -- for manual installation instructions, do :help lspconfig-all

            -- lua
            require("lspconfig").lua_ls.setup({ capabilities = capabilities })

            -- go
            require("lspconfig").gopls.setup({ capabilities = capabilities })

            -- webdev
            require("lspconfig").ts_ls.setup({ capabilities = capabilities })
            require("lspconfig").tailwindcss.setup({ capabilities = capabilities })
            require("lspconfig").biome.setup({ capabilities = capabilities })

            -- python
            require("lspconfig").pyright.setup({
                capabilities = capabilities,
                settings = {
                    python = {
                        venvPath = "./.venv/",
                        disableLanguageServices = false,
                        disableOrganizeImports = true,
                        disableTaggedHints = false,
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "workspace",
                            useLibraryCodeForTypes = true,
                            autoImportCompletions = true,
                            typeCheckingMode = "standard",
                            extraPaths = {
                                "packages/coalition-persistent-data-manager/src",
                                "rating_model",
                                "service_clients",
                            },
                        },
                    },
                },
            })

            -- markdown
            require("lspconfig").marksman.setup({ capabilities = capabilities })

            -- Diagnostics, virtual lines and virtual text
            vim.diagnostic.config({
                virtual_text = true,
                virtual_lines = { current_line = true },
                underline = true,
                update_in_insert = false,
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("my.lsp", {}),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)

                    if not client then
                        return
                    end

                    -- Override LSP keymaps to use telescope
                    vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions)
                    vim.keymap.set("n", "grr", require("telescope.builtin").lsp_references)
                    vim.keymap.set("n", "grt", require("telescope.builtin").lsp_type_definitions)

                    -- Prefer LSP folding if client supports it
                    if client:supports_method("textDocument/foldingRange") then
                        local win = vim.api.nvim_get_current_win()
                        vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
                    end
                end,
            })
        end,
    },
    {
        "saghen/blink.cmp",
        dependencies = "rafamadriz/friendly-snippets",
        version = "*",
        opts = {
            keymap = { preset = "default" },
            appearance = {
                nerd_font_variant = "mono",
            },
            signature = { enabled = true },
            completion = {
                documentation = {
                    auto_show = true,
                },
            },
        },
    },
    { -- Autoformat
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = "",
                desc = "[F]ormat buffer",
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                if
                    vim.g.disable_autoformat
                    or vim.b[bufnr].disable_autoformat
                    or vim.bo[bufnr].filetype == "python"
                then
                    return
                end
                return {
                    timeout_ms = 5000,
                    lsp_format = "fallback",
                }
            end,
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "gofmt" },
                typescript = { "biome" },
                typescriptreact = { "biome" },
                javascript = { "biome" },
                javascriptreact = { "biome" },
            },
        },
    },
}
