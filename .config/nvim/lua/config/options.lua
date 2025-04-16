vim.opt.clipboard = "unnamedplus" -- System clipboard

vim.opt.smartcase = true          -- Enable smart-case search: if search pattern contains uppercase, then search becomes case-sensitive
vim.opt.ignorecase = true         -- Ignore case in search

vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = true     -- Show relative line numbers
vim.opt.splitbelow = true         -- Open new splits below the current window
vim.opt.splitright = true         -- Open new splits to the right of the current window

vim.opt.signcolumn = "yes"        -- Always show the sign column, even when empty
vim.opt.wrap = true               -- Enable line wrapping
vim.opt.linebreak = true          -- Softly wrap lines at word boundaries
vim.opt.tabstop = 4               -- Number of spaces a Tab key stroke occupies
vim.opt.softtabstop = 4           -- Number of spaces for inserting Tab
vim.opt.shiftwidth = 4            -- Number of spaces to use for autoindenting
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.smartindent = true        -- Automatically insert indentation

vim.opt.showmode = false          -- Dont show mode because status line already shows it
vim.g.pyindent_open_paren = 0     -- Disable extra indent level after open parenthesis in python
vim.opt.undofile = true           -- Enable persistent undo
vim.opt.inccommand = "split"      -- Show substitution live
vim.opt.cursorline = true         -- Highlight cursor line
vim.opt.scrolloff = 10            -- Keep at least 10 lines visible above and below cursor when scrolling

vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.diffopt = {
    "internal",            -- Use the internal diff algorithm
    "filler",              -- Show filler lines for missing lines in the diff
    "closeoff",            -- Close the diff view when all buffers are closed
    "context:12",          -- Show 12 lines of context around changes
    "algorithm:histogram", -- Use the histogram algorithm for better diff results
    "linematch:200",       -- Perform line-level matching for up to 200 lines
    "indent-heuristic"     -- Use heuristics to improve diff alignment based on indentation
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
vim.keymap.set('n', '<leader>z', 'za', { desc = 'Toggle fold' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- Clear highlighted search on escape

vim.keymap.set('n', '<C-d>', '<C-d>zz')             -- Recenter cursor for half page scroll
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set('n', 'n', 'nzzzv') -- Recenter cursor for search
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste without replacing buffer content' })
vim.keymap.set('n', '<leader>d', [["_d]], { desc = 'Delete without replacing buffer content' })

-- Search and replace
vim.keymap.set('n', '<leader>r', '*``cgn', { desc = 'Search current word and edit next occurrence' })

-- Diff highlighting
vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#20303b" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#37222c" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1f2231" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#394b70" })

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end
})
