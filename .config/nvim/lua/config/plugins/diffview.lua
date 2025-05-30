return {
    {
        'sindrets/diffview.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        config = function()
            local actions = require("diffview.actions")
            require("diffview").setup {
                view = {
                    default = {
                        layout = "diff2_vertical"
                    }
                },
                keymaps = {
                    view = {
                        { "n", "q", actions.close, { desc = "Close help menu" } },
                    },
                    file_panel = {
                        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close help menu" } },
                    },
                    file_history_panel = {
                        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close help menu" } },
                    },
                },
            }

            local function get_default_branch_name()
                local res = vim.system({ 'git', 'rev-parse', '--verify', 'main' }, { capture_output = true }):wait()
                return res.code == 0 and 'main' or 'master'
            end
            vim.keymap.set("n", "<leader>gdd", function() vim.cmd("DiffviewOpen") end, { desc = "Diff against HEAD" })
            vim.keymap.set("n", "<leader>gdm", function() vim.cmd('DiffviewOpen ' .. get_default_branch_name()) end,
                { desc = "Diff against main/master" })
            vim.keymap.set("n", "<leader>gdM",
                function() vim.cmd('DiffviewOpen HEAD..origin/' .. get_default_branch_name()) end,
                { desc = "Diff against remote main/master" })
            vim.keymap.set("n", "<leader>gh", function() vim.cmd("DiffviewFileHistory %") end)
        end
    }
}
