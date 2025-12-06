return {
    {
        "ibhagwan/fzf-lua",
        dependencies = {},
        ---@type fzf-lua.Config
        opts = {
            { "hide", "ivy" },
            defaults = {
                formatter = "path.filename_first",
            },
            winopts = {
                height = 0.95,
                width = 0.95,
                preview = {
                    horizontal = "right:30%",
                    layout = "horizontal",
                },
            },
            keymap = {
                fzf = {
                    ["ctrl-q"] = "select-all+accept", -- send all to quickfix
                    ["ctrl-n"] = "down",
                    ["ctrl-p"] = "up",
                },
            },
            files = {
                git_icons = true,
                cwd_prompt = true,
            },
            oldfiles = {
                cwd_only = true,
                include_current_session = true,
            },
        },
        keys = {
            { "<leader>sh", function() require("fzf-lua").helptags() end,              desc = "[S]earch [H]elp" },
            { "<leader>sb", function() require("fzf-lua").buffers() end,               desc = "[S]earch [B]uffers" },
            { "<leader>sk", function() require("fzf-lua").keymaps() end,               desc = "[S]earch [K]eymaps" },
            { "<leader>sf", function() require("fzf-lua").files() end,                 desc = "[S]earch [F]iles" },
            { "<leader>sg", function() require("fzf-lua").live_grep_native() end,      desc = "[S]earch [G]rep" },
            { "<leader>sd", function() require("fzf-lua").diagnostics_workspace() end, desc = "[S]earch [D]iagnostics" },
            { "<leader>/",  function() require("fzf-lua").blines() end,                desc = "[/] Fuzzily search in current buffer" },
            { "<leader>sm", function() require("fzf-lua").marks() end,                 desc = "[S]earch [M]arks" },
            { "<leader>sq", function() require("fzf-lua").quickfix() end,              desc = "[S]earch [Q]uickfix" },
            { "<leader>gb", function() require("fzf-lua").git_branches() end,          desc = "[G]it [B]ranch" },
            { "<leader>gc", function() require("fzf-lua").git_bcommits() end,          desc = "[G]it Buffer [C]ommits" },
            { "<leader>gs", function() require("fzf-lua").git_status() end,            desc = "[G]it [S]tatus" },
            { "<leader>gl", function() require("fzf-lua").git_commits() end,           desc = "[G]it [L]og" },
            { "<leader>tr", function() require("fzf-lua").resume() end,                desc = "Resume last picker" },
            -- LSP keymaps
            { "gd",         function() require("fzf-lua").lsp_definitions() end,       desc = "LSP Definitions" },
            { "grr",        function() require("fzf-lua").lsp_references() end,        desc = "LSP References" },
            { "gri",        function() require("fzf-lua").lsp_implementations() end,   desc = "LSP Implementations" },
            { "grt",        function() require("fzf-lua").lsp_typedefs() end,          desc = "LSP Type Definitions" },
        },
        config = function(_, opts)
            require("fzf-lua").setup(opts)
            require("fzf-lua").register_ui_select()
        end,
    },
}
