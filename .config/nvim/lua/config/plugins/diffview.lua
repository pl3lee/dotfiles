return {
    {
        'sindrets/diffview.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        config = function()
            local actions = require("diffview.actions")
            require("diffview").setup {
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
            vim.keymap.set("n", "<leader>gd", function() vim.cmd("DiffviewOpen") end)
            vim.keymap.set("n", "<leader>gh", function() vim.cmd("DiffviewFileHistory %") end)
        end
    }
}
