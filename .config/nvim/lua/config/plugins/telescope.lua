return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        'nvim-telescope/telescope-frecency.nvim'
    },
    config = function()
        local builtin = require 'telescope.builtin'
        require('telescope').setup {
            extensions = {
                fzf = {
                    fuzzy = true,                    -- false will only do exact matching
                    override_generic_sorter = true,  -- override the generic sorter
                    override_file_sorter = true,     -- override the file sorter
                    case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                }
            }
        }
        require('telescope').load_extension('fzf')

        -- Remember search
        local last_picker_time = nil
        local last_picker = nil
        local function resume_or_run(picker, opts)
            local current_time = os.time()
            if last_picker == picker and last_picker_time and (current_time - last_picker_time <= 300) then
                builtin.resume()
            else
                picker(opts)
                last_picker = picker
                last_picker_time = current_time
            end
        end

        vim.keymap.set('n', '<leader>sh', function()
            resume_or_run(builtin.help_tags, { desc = '[S]earch [H]elp' })
        end)
        vim.keymap.set('n', '<leader>sk', function()
            resume_or_run(builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        end)
        vim.keymap.set('n', '<leader>sf', function()
            resume_or_run(builtin.find_files, {
                find_command = { 'rg', '--files', '--hidden', '--glob', '!.git' },
                desc = '[S]earch [F]iles',
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

        vim.keymap.set('n', '<leader>s/', function()
            resume_or_run(builtin.live_grep, {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
                desc = '[S]earch [/] in Open Files',
            })
        end)

        vim.keymap.set('n', '<leader>sn', function()
            resume_or_run(builtin.find_files, {
                cwd = vim.fn.stdpath 'config',
                desc = '[S]earch [N]eovim files',
            })
        end)
    end
}
