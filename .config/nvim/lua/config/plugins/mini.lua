return {
    {
        "nvim-mini/mini.nvim",
        config = function()
            local icons = require("mini.icons")
            icons.setup({})

            local statusline = require("mini.statusline")
            statusline.setup({ use_icons = true })

            local minifiles = require("mini.files")
            minifiles.setup({
                mappings = {
                    synchronize = "w",
                    go_in_plus = "<CR>",
                },
            })

            -- Opens Mini Files at current working directory
            vim.keymap.set("n", "\\", function()
                local buf_name = vim.api.nvim_buf_get_name(0)
                local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
                MiniFiles.open(path)
                MiniFiles.reveal_cwd()
            end, { desc = "Open Mini Files" })

            local surround = require("mini.surround")
            surround.setup({})

            local indentscope = require("mini.indentscope")
            indentscope.setup({})

            local jump2d = require("mini.jump2d")
            jump2d.setup({})

            local notify = require("mini.notify")
            notify.setup({})

            local bracketed = require("mini.bracketed")
            bracketed.setup({})

            local ai = require("mini.ai")
            ai.setup({})
        end,
    },
}
