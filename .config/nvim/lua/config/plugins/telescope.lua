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

        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>sf', function()
            frecency_picker({
                desc = '[S]earch [F]iles',
                workspace = "CWD",
            })
        end)
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

        vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer' })

        vim.keymap.set('n', '<leader>ss', builtin.treesitter, { desc = '[S]earch [S]ymbols' })

        vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranch' })

        vim.keymap.set('n', '<leader>gc', builtin.git_bcommits, { desc = '[G]it Buffer [C]ommits' })

        vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })

        vim.keymap.set('n', '<leader>gl', builtin.git_commits, { desc = '[G]it [L]og' })

        vim.keymap.set('n', '<leader>tr', builtin.resume, { desc = '[T]elescope [R]esume' })
    end
}
