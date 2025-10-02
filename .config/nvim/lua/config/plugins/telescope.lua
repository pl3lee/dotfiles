return {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "folke/trouble.nvim",
        "danielfalk/smart-open.nvim",
        "kkharji/sqlite.lua",
    },

    config = function()
        local builtin = require("telescope.builtin")
        local actions = require("telescope.actions")
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local make_entry = require("telescope.make_entry")
        local conf = require("telescope.config").values
        local open_with_trouble = require("trouble.sources.telescope").open
        require("telescope").setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-s>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<c-t>"] = open_with_trouble,
                    },
                    n = { ["<c-t>"] = open_with_trouble },
                },
                path_display = {
                    "filename_first",
                    truncate = 5,
                },
                dynamic_preview_title = true,
            },
            pickers = {},
            extensions = {
                smart_open = {
                    show_scores = true,
                    match_algorithm = "fzf",
                    layout_config = {
                        height = 0.95,
                        width = 0.95,
                        preview_width = 0.3,
                    },
                }
            },
        })
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("smart_open")

        local live_multigrep = function(opts)
            opts = opts or {}
            opts.cwd = opts.cwd or vim.uv.cwd()

            local finder = finders.new_async_job({
                command_generator = function(prompt)
                    if not prompt or prompt == "" then
                        return nil
                    end
                    local pieces = vim.split(prompt, "  ")
                    local args = { "rg" }
                    if pieces[1] then
                        table.insert(args, "-e")
                        table.insert(args, pieces[1])
                    end

                    -- Additional filtering
                    if #pieces > 1 then
                        for i = 2, #pieces do
                            if pieces[i] then
                                table.insert(args, "-g")
                                table.insert(args, pieces[i])
                            end
                        end
                    end

                    return (function()
                        vim.list_extend(args, {
                            "--color=never",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                            "--smart-case",
                        })
                        return args
                    end)()
                end,
                entry_maker = make_entry.gen_from_vimgrep(opts),
                cwd = opts.cwd,
            })

            pickers
                .new(opts, {
                    debounce = 100,
                    prompt_title = "Multi Grep",
                    finder = finder,
                    previewer = conf.grep_previewer(opts),
                    sorter = require("telescope.sorters").empty(),
                })
                :find()
        end

        vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
        vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
        vim.keymap.set("n", "<leader>sf", function()
            require("telescope").extensions.smart_open.smart_open({
                layout_config = {
                    height = 0.95,
                    width = 0.95,
                    preview_width = 0.3,
                },
                cwd_only = true,
                filename_first = true,
            })
        end)
        vim.keymap.set("n", "<leader>sg", function()
            live_multigrep({
                layout_strategy = "horizontal",
                layout_config = {
                    height = 0.95,
                    width = 0.95,
                    preview_width = 0.4,
                },
            })
        end)
        vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })

        vim.keymap.set("n", "<leader>/", function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                winblend = 10,
                previewer = false,
            }))
        end, { desc = "[/] Fuzzily search in current buffer" })

        vim.keymap.set("n", "<leader>ss", builtin.treesitter, { desc = "[S]earch [S]ymbols" })

        vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "[S]earch [M]arks" })

        vim.keymap.set("n", "<leader>sq", builtin.quickfix, { desc = "[S]earch [Q]uickfix" })

        vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "[G]it [B]ranch" })

        vim.keymap.set("n", "<leader>gc", builtin.git_bcommits, { desc = "[G]it Buffer [C]ommits" })

        vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "[G]it [S]tatus" })

        vim.keymap.set("n", "<leader>gl", builtin.git_commits, { desc = "[G]it [L]og" })

        vim.keymap.set("n", "<leader>tr", builtin.resume, { desc = "[T]elescope [R]esume" })
    end,
}
