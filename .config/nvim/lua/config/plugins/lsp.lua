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
            "mason-org/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local blink_capabilities = require("blink.cmp").get_lsp_capabilities()

            mason.setup()
            mason_lspconfig.setup({
                ensure_installed = {
                    "lua_ls",
                    "gopls",
                    "ts_ls",
                    "tailwindcss",
                    "biome",
                    "jsonls",
                    "basedpyright",
                    -- "ty",

                    -- Used in conform, no need setup
                    "ruff",
                    "marksman",
                    "buf_ls",
                },
                automatic_enable = {
                    exclude = {
                        "lua_ls",
                        "gopls",
                        "ts_ls",
                        "tailwindcss",
                        "biome",
                        "jsonls",
                        "basedpyright",
                        "ty",
                        "ruff",
                        "marksman",
                        "buf_ls",
                    },
                },
            })

            -- Override LSP keymaps to use telescope
            vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions)
            vim.keymap.set("n", "grr", function()
                require("telescope.builtin").lsp_references({
                    layout_strategy = "horizontal",
                    layout_config = {
                        height = 0.95,
                        width = 0.95,
                        preview_width = 0.4,
                    },
                })
            end)
            vim.keymap.set("n", "gri", function()
                require("telescope.builtin").lsp_implementations({
                    layout_strategy = "horizontal",
                    layout_config = {
                        height = 0.95,
                        width = 0.95,
                        preview_width = 0.4,
                    },
                })
            end)
            vim.keymap.set("n", "grt", require("telescope.builtin").lsp_type_definitions)

            local on_attach = function(client, bufnr)
                local bufopts = { buffer = bufnr, remap = false }

                -- Disable LSP for diffview buffers (they use diffview:// scheme)
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                if bufname:match("^diffview://") then
                    vim.schedule(function()
                        vim.lsp.buf_detach_client(bufnr, client.id)
                    end)
                    return
                end

                -- Prefer LSP folding if client supports it
                if client:supports_method("textDocument/foldingRange") then
                    local win = vim.api.nvim_get_current_win()
                    vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
                end

                -- Enable inlay hints only in normal mode
                if client:supports_method("textDocument/inlayHint") then
                    -- show hints initially
                    vim.lsp.inlay_hint.enable(true)

                    -- disable hints in insert mode
                    vim.api.nvim_create_autocmd("InsertEnter", {
                        callback = function()
                            vim.lsp.inlay_hint.enable(false)
                        end,
                    })
                    -- re-enable on leaving insert
                    vim.api.nvim_create_autocmd("InsertLeave", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.inlay_hint.enable(true)
                        end,
                    })
                end
            end


            local servers = {
                lua_ls = {},
                gopls = {
                    settings = {
                        gopls = {
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = false,
                                functionTypeParameters = false,
                                ignoredError = true,
                                parameterNames = true,
                                rangeVariableTypes = true,
                            }
                        },
                    }
                },
                ts_ls = {},
                tailwindcss = {},
                biome = {},
                marksman = {},
                buf_ls = {},
                jsonls = {
                    -- lazy-load schemastore when needed
                    on_new_config = function(new_config)
                        new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                        vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
                    end,
                    settings = {
                        json = {
                            format = { enable = true },
                            validate = { enable = true },
                        },
                    },
                },
                -- ty = {
                --     settings = {
                --         ty = {
                --             diagnosticMode = 'workspace',
                --             experimental = {
                --                 autoImport = true,
                --                 rename = true,
                --             },
                --         }
                --     }
                --
                -- },
                basedpyright = {
                    settings = {
                        basedpyright = {
                            venvPath = "./.venv/",
                            disableLanguageServices = false,
                            disableOrganizeImports = true,
                            disableTaggedHints = false,
                            analysis = {
                                fileEnumerationTimeout = 300,
                                autoFormatStrings = true,
                                autoSearchPaths = true,
                                diagnosticMode = "openFilesOnly",
                                useLibraryCodeForTypes = true,
                                autoImportCompletions = true,
                                typeCheckingMode = "standard",
                                extraPaths = {
                                    "packages/coalition-persistent-data-manager/src",
                                },
                                inlayHints = {
                                    variableTypes = true,
                                    callArgumentNames = true,
                                    functionReturnTypes = true,
                                    genericTypes = true,
                                },
                            },
                        },
                    },
                },
            }

            for name, override in pairs(servers) do
                local opts = vim.tbl_deep_extend("force", {
                    on_attach = on_attach,
                    capabilities = blink_capabilities,
                }, override)
                vim.lsp.config(name, opts)
            end
            for name in pairs(servers) do
                vim.lsp.enable(name)
            end

            -- Diagnostics, virtual lines and virtual text
            vim.diagnostic.config({
                virtual_text = true,
                virtual_lines = { current_line = true },
                underline = true,
                update_in_insert = false,
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
                keyword = { range = "full" },
                accept = { auto_brackets = { enabled = false } },
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
            log_level = vim.log.levels.DEBUG,
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
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
                python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
                typescript = { "biome" },
                typescriptreact = { "biome" },
                javascript = { "biome" },
                javascriptreact = { "biome" },
            },
        },
    },
}
