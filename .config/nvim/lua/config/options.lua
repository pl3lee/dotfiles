vim.opt.clipboard = "unnamedplus" -- System clipboard

vim.opt.smartcase = true -- Enable smart-case search: if search pattern contains uppercase, then search becomes case-sensitive
vim.opt.ignorecase = true -- Ignore case in search

vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.splitbelow = true -- Open new splits below the current window
vim.opt.splitright = true -- Open new splits to the right of the current window

vim.opt.signcolumn = "yes" -- Always show the sign column, even when empty
vim.opt.wrap = true -- Enable line wrapping
vim.opt.linebreak = true -- Softly wrap lines at word boundaries
vim.opt.tabstop = 4 -- Number of spaces a Tab key stroke occupies
vim.opt.softtabstop = 4 -- Number of spaces for inserting Tab
vim.opt.shiftwidth = 4 -- Number of spaces to use for autoindenting
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Automatically insert indentation

vim.opt.showmode = false -- Dont show mode because status line already shows it
vim.g.pyindent_open_paren = 0 -- Disable extra indent level after open parenthesis in python
vim.opt.undofile = true -- Enable persistent undo
vim.opt.inccommand = "split" -- Show substitution live
vim.opt.cursorline = true -- Highlight cursor line
vim.opt.scrolloff = 10 -- Keeps cursor centered when scrolling

-- remap j → gj, k → gk when no count is given:
vim.keymap.set("n", "j", function()
    return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true })

vim.keymap.set("n", "k", function()
    return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true })

vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Diff highlighting
vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#20303b" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#37222c" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1f2231" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#394b70" })
vim.opt.diffopt = {
    "internal", -- Use the internal diff algorithm
    "filler", -- Show filler lines for missing lines in the diff
    "closeoff", -- Close the diff view when all buffers are closed
    "context:12", -- Show 12 lines of context around changes
    "algorithm:histogram", -- Use the histogram algorithm for better diff results
    "linematch:200", -- Perform line-level matching for up to 200 lines
    "indent-heuristic", -- Use heuristics to improve diff alignment based on indentation
}

-- Folds
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldtext = ""
vim.opt.foldcolumn = "0"
vim.opt.fillchars:append({ fold = " " })
-- Default to treesitter folding
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.keymap.set("n", "<leader>z", "za", { desc = "Toggle fold" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- Clear highlighted search on escape

vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Recenter cursor for half page scroll
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv") -- Recenter cursor for search
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without replacing buffer content" })
vim.keymap.set("n", "<leader>d", [["_d]], { desc = "Delete without replacing buffer content" })

-- Quick fix
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>", { desc = "Quickfix next" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>", { desc = "Quickfix prev" })

-- Search and replace
vim.keymap.set("n", "<leader>r", "*``cgn", { desc = "Search current word and edit next occurrence" })

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Copy absolute path to clipboard
vim.api.nvim_create_user_command("CopyAbsPath", function()
    local abs_path = vim.fn.expand("%:p")
    if abs_path == "" or abs_path == vim.fn.getcwd() then
        vim.notify("No file name to copy absolute path from.", vim.log.levels.WARN, { title = "Clipboard" })
        return
    end

    vim.fn.setreg("+", abs_path)
    vim.notify('Copied absolute path: "' .. abs_path .. '"', vim.log.levels.INFO, { title = "Clipboard" })
end, {})

-- Copy relative path to clipboard
vim.api.nvim_create_user_command("CopyRelPath", function()
    local abs_path = vim.fn.expand("%:p") -- Get the full absolute path first
    if abs_path == "" or abs_path == vim.fn.getcwd() then
        vim.notify("No file name to copy relative path from.", vim.log.levels.WARN, { title = "Clipboard" })
        return
    end

    -- Now make it relative to the current working directory
    local rel_path = vim.fn.fnamemodify(abs_path, ":.")

    -- If the file is in the current directory, rel_path will just be the filename.
    -- If it's in a subdirectory, it'll be e.g., "subdir/file.txt".
    -- If it's in a parent directory, it'll be e.g., "../file.txt".

    vim.fn.setreg("+", rel_path)
    vim.notify('Copied relative path: "' .. rel_path .. '"', vim.log.levels.INFO, { title = "Clipboard" })
end, {})
