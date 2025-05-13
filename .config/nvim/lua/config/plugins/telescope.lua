return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        'nvim-telescope/telescope-frecency.nvim',
    },
    config = function()
        local builtin = require 'telescope.builtin'
        local frecency_picker = require('telescope').extensions.frecency.frecency
        require('telescope').setup {
            extensions = {
                fzf = {
                    fuzzy = true,                   -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true,    -- override the file sorter
                    case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
                frecency = {
                    auto_validate = false,
                    matcher = "fuzzy",
                    path_display = { "filename_first" },
                },
            }
        }
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('frecency')

        -- Remember search
        local last_picker_time = nil
        local last_picker = nil
        local function resume_or_run(picker, opts)
            opts = opts or {}
            opts = vim.tbl_deep_extend("keep", opts, { attach_mappings = function(_, map) return true end })
            local now = os.time()
            if last_picker == picker and last_picker_time and (now - last_picker_time <= 300) then
                builtin.resume()
            else
                picker(opts)
                last_picker = picker
                last_picker_time = now
            end
        end

        vim.keymap.set('n', '<leader>sh', function()
            resume_or_run(builtin.help_tags, { desc = '[S]earch [H]elp' })
        end)
        vim.keymap.set('n', '<leader>sk', function()
            resume_or_run(builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        end)
        vim.keymap.set('n', '<leader>sf', function()
            resume_or_run(frecency_picker, {
                desc = '[S]earch [F]iles',
                workspace = "CWD",
            })
        end)
        vim.keymap.set('n', '<leader>sg', function()
            resume_or_run(builtin.live_grep, { desc = '[S]earch by [G]rep' })
        end)
        vim.keymap.set('n', '<leader>sd', function()
            resume_or_run(builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        end)

        vim.keymap.set('n', '<leader>/', function()
            resume_or_run(builtin.current_buffer_fuzzy_find, require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
                desc = '[/] Fuzzily search in current buffer',
            })
        end)

        vim.keymap.set('n', '<leader>ss', function()
            resume_or_run(builtin.treesitter, { desc = '[S]earch [S]ymbols' })
        end)

        vim.keymap.set('n', '<leader>gb', function()
            resume_or_run(builtin.git_branches, { desc = '[G]it [B]ranch' })
        end)

        vim.keymap.set('n', '<leader>gc', function()
            resume_or_run(builtin.git_bcommits, { desc = '[G]it Buffer [C]ommits' })
        end)

        vim.keymap.set('n', '<leader>gs', function()
            resume_or_run(builtin.git_status, { desc = '[G]it [S]tatus' })
        end)

        vim.keymap.set('n', '<leader>gl', function()
            resume_or_run(builtin.git_commits, { desc = '[G]it [L]og' })
        end)
    end
}
