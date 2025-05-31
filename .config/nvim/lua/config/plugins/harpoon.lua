return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            -- show items
            vim.keymap.set("n", "<leader>h", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end)

            -- add to end of list
            vim.keymap.set("n", "<leader><leader>0", function()
                harpoon:list():add()
            end)
            -- clear list
            vim.keymap.set("n", "<leader><leader>-", function()
                harpoon:list():clear()
            end)

            -- setting items
            vim.keymap.set("n", "<leader><leader>1", function()
                harpoon:list():replace_at(1)
            end)
            vim.keymap.set("n", "<leader><leader>2", function()
                harpoon:list():replace_at(2)
            end)
            vim.keymap.set("n", "<leader><leader>3", function()
                harpoon:list():replace_at(3)
            end)
            vim.keymap.set("n", "<leader><leader>5", function()
                harpoon:list():replace_at(5)
            end)
            vim.keymap.set("n", "<leader><leader>6", function()
                harpoon:list():replace_at(6)
            end)
            vim.keymap.set("n", "<leader><leader>7", function()
                harpoon:list():replace_at(7)
            end)
            vim.keymap.set("n", "<leader><leader>8", function()
                harpoon:list():replace_at(8)
            end)
            vim.keymap.set("n", "<leader><leader>9", function()
                harpoon:list():replace_at(9)
            end)

            -- jump to items
            vim.keymap.set("n", "<leader>1", function()
                harpoon:list():select(1)
            end)
            vim.keymap.set("n", "<leader>2", function()
                harpoon:list():select(2)
            end)
            vim.keymap.set("n", "<leader>3", function()
                harpoon:list():select(3)
            end)
            vim.keymap.set("n", "<leader>4", function()
                harpoon:list():select(4)
            end)
            vim.keymap.set("n", "<leader>5", function()
                harpoon:list():select(5)
            end)
            vim.keymap.set("n", "<leader>6", function()
                harpoon:list():select(6)
            end)
            vim.keymap.set("n", "<leader>7", function()
                harpoon:list():select(7)
            end)
            vim.keymap.set("n", "<leader>8", function()
                harpoon:list():select(8)
            end)
            vim.keymap.set("n", "<leader>9", function()
                harpoon:list():select(9)
            end)
        end,
    },
}
