return {
    {
        "folke/snacks.nvim",
        ---@type snacks.Config
        opts = {
            image = {
                enabled = true,
            },
            scratch = {
                enabled = true,
            },
            gitbrowse = {
                enabled = true,
            },
            bufdelete = {
                enabled = true,
            },
        },
        keys = {
            {
                "<leader>bd",
                function()
                    Snacks.bufdelete()
                end,
                desc = "Delete Buffer",
            },
            {
                "<leader>bo",
                function()
                    Snacks.bufdelete.other()
                end,
                desc = "Delete Other Buffers",
            },
            {
                "<leader>.",
                function()
                    Snacks.scratch()
                end,
                desc = "Toggle Scratch Buffer",
            },
            {
                "<leader>S",
                function()
                    Snacks.scratch.select()
                end,
                desc = "Select Scratch Buffer",
            },
            {
                "<leader><leader>gb",
                function()
                    Snacks.gitbrowse()
                end,
                desc = "Git browse",
            },
        },
    },
}
