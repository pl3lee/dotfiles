return {
    {
        'github/copilot.vim',
        config = function()
            vim.g.copilot_enabled = false
        end,

    },
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        dependencies = {
            { 'github/copilot.vim' },
            { 'nvim-lua/plenary.nvim', branch = 'master' },
        },
        build = 'make tiktoken',
        opts = {
            sticky = {
                '$gemini-2.5-pro',
                '#buffer',
                "#files"
            },
            mappings = {
                reset = {
                    normal = '<leader>gcr',
                    insert = '<C-l>'
                }
            }
        },
        config = function(_, opts)
            local chat = require("CopilotChat")
            chat.setup(opts)
            vim.keymap.set("n", "<leader>gco", function() chat.toggle() end)
            vim.keymap.set("n", "<leader>gcs", function() chat.stop() end)
        end
    },
}
