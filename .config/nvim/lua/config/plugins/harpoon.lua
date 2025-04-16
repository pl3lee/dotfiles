return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            -- show items
            vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

            -- setting items
            vim.keymap.set("n", "<leader><leader>j", function() harpoon:list():replace_at(1) end)
            vim.keymap.set("n", "<leader><leader>k", function() harpoon:list():replace_at(2) end)
            vim.keymap.set("n", "<leader><leader>l", function() harpoon:list():replace_at(3) end)
            vim.keymap.set("n", "<leader><leader>;", function() harpoon:list():replace_at(4) end)

            -- jump to items
            vim.keymap.set("n", "<leader>j", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<leader>k", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<leader>l", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<leader>;", function() harpoon:list():select(4) end)
        end
    }
}
