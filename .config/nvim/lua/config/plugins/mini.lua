return {
    {
        'echasnovski/mini.nvim',
        config = function()
            local icons = require 'mini.icons'
            icons.setup {}

            local statusline = require 'mini.statusline'
            statusline.setup { use_icons = true }

            local minifiles = require 'mini.files'
            minifiles.setup {
                mappings = {
                    synchronize = "w",
                    go_in_plus = "<CR>",
                },
            }
            vim.keymap.set("n", "\\", "<cmd>lua MiniFiles.open()<CR>", { desc = "Mini Files Open" })

            local autopairs = require 'mini.pairs'
            autopairs.setup {}

            local surround = require 'mini.surround'
            surround.setup {}

            local indentscope = require 'mini.indentscope'
            indentscope.setup {}
        end
    }
}
