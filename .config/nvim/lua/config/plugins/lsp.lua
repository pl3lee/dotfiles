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
        },
        config = function()
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            -- Define LSPs here
            -- Need to install LSPs manually, do :help lspconfig-all for installation instructions

            -- lua
            require("lspconfig").lua_ls.setup { capabilities = capabilities }

            -- go
            require("lspconfig").gopls.setup { capabilities = capabilities }
            -- require("lspconfig").golangci_lint_ls.setup {
            --     capabilities = capabilities,
            --     init_options = {
            --         command = { "golangci-lint", "run", "--show-stats=false" }
            --     }
            -- }

            -- webdev
            require("lspconfig").ts_ls.setup { capabilities = capabilities }
            require("lspconfig").tailwindcss.setup { capabilities = capabilities }
            require("lspconfig").biome.setup { capabilities = capabilities }

            -- python
            require("lspconfig").pyright.setup { capabilities = capabilities }

            -- markdown
            require("lspconfig").marksman.setup { capabilities = capabilities }

            -- Diagnostics, virtual lines and virtual text
            vim.diagnostic.config({
                virtual_text = true,
                virtual_lines = { current_line = true },

                underline = true,
                update_in_insert = false
            })
            local og_virt_text
            local og_virt_line
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'DiagnosticChanged' }, {
                group = vim.api.nvim_create_augroup('diagnostic_only_virtlines', {}),
                callback = function()
                    if og_virt_line == nil then
                        og_virt_line = vim.diagnostic.config().virtual_lines
                    end

                    -- ignore if virtual_lines.current_line is disabled
                    if not (og_virt_line and og_virt_line.current_line) then
                        if og_virt_text then
                            vim.diagnostic.config({ virtual_text = og_virt_text })
                            og_virt_text = nil
                        end
                        return
                    end

                    if og_virt_text == nil then
                        og_virt_text = vim.diagnostic.config().virtual_text
                    end

                    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

                    if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = lnum })) then
                        vim.diagnostic.config({ virtual_text = og_virt_text })
                    else
                        vim.diagnostic.config({ virtual_text = false })
                    end
                end
            })
            vim.api.nvim_create_autocmd('ModeChanged', {
                group = vim.api.nvim_create_augroup('diagnostic_redraw', {}),
                callback = function()
                    pcall(vim.diagnostic.show)
                end
            })

            -- Format on save
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('my.lsp', {}),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)

                    if not client then return end

                    -- Override LSP keymaps to use telescope
                    vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions)
                    vim.keymap.set('n', 'grr', require('telescope.builtin').lsp_references)
                    vim.keymap.set('n', 'grt', require('telescope.builtin').lsp_type_definitions)


                    -- Auto-format ("lint") on save.
                    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
                    if not client:supports_method('textDocument/willSaveWaitUntil')
                        and client:supports_method('textDocument/formatting') then
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                            end,
                        })
                    end
                end,
            })

            -- Prefer LSP folding if client supports it
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end
                    if client:supports_method('textDocument/foldingRange') then
                        local win = vim.api.nvim_get_current_win()
                        vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
                    end
                end
            })
        end
    },
    {
        "saghen/blink.cmp",
        dependencies = 'rafamadriz/friendly-snippets',
        version = "*",
        opts = {
            keymap = { preset = 'default' },
            appearance = {
                nerd_font_variant = 'mono'
            },
            signature = { enabled = true }
        }
    }
}
