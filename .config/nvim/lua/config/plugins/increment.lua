return {
    {
        "monaqa/dial.nvim",
        keys = {
            {
                "<C-a>",
                function()
                    return require("dial.map").inc_normal()
                end,
                expr = true,
                desc = "Increment",
                mode = { "n", "v" },
            },
            {
                "<C-x>",
                function()
                    return require("dial.map").dec_normal()
                end,
                expr = true,
                desc = "Decrement",
                mode = { "n", "v" },
            },
            {
                "g<C-a>",
                function()
                    return require("dial.map").inc_gvisual()
                end,
                expr = true,
                desc = "Increment (inside visual)",
                mode = { "n", "v" },
            },
            {
                "g<C-x>",
                function()
                    return require("dial.map").dec_gvisual()
                end,
                expr = true,
                desc = "Decrement (inside visual)",
                mode = { "n", "v" },
            },
        },

        opts = function()
            local augend = require("dial.augend")
            local logical_alias = augend.constant.new({
                elements = { "&&", "||" },
                word = false,
                cyclic = true,
            })
            local ordinal_numbers = augend.constant.new({
                elements = {
                    "first",
                    "second",
                    "third",
                    "fourth",
                    "fifth",
                    "sixth",
                    "seventh",
                    "eighth",
                    "ninth",
                    "tenth",
                },
                word = false,
                cyclic = true,
            })
            local weekdays = augend.constant.new({
                elements = {
                    "Monday",
                    "Tuesday",
                    "Wednesday",
                    "Thursday",
                    "Friday",
                    "Saturday",
                    "Sunday",
                },
                word = true,
                cyclic = true,
            })
            local months = augend.constant.new({
                elements = {
                    "January",
                    "February",
                    "March",
                    "April",
                    "May",
                    "June",
                    "July",
                    "August",
                    "September",
                    "October",
                    "November",
                    "December",
                },
                word = true,
                cyclic = true,
            })
            local capitalized_boolean = augend.constant.new({
                elements = { "True", "False" },
                word = true,
                cyclic = true,
            })

            return {
                -- filetype → which group to use
                dials_by_ft = {
                    css = "css",
                    scss = "css",
                    sass = "css",
                    vue = "vue",
                    javascript = "typescript",
                    typescript = "typescript",
                    javascriptreact = "typescript",
                    typescriptreact = "typescript",
                    json = "json",
                    lua = "lua",
                    markdown = "markdown",
                    python = "python",
                },

                -- augend groups
                groups = {
                    default = {
                        augend.integer.alias.decimal,     -- 0,1,2,3…
                        augend.integer.alias.decimal_int, -- -1,0,1,2…
                        augend.integer.alias.hex,         -- 0x1a, 0xFF…
                        augend.date.alias["%Y/%m/%d"],    -- 2023/01/31…
                        ordinal_numbers,
                        weekdays,
                        months,
                        capitalized_boolean,
                        augend.constant.alias.bool, -- true <-> false
                        logical_alias,
                    },
                    vue = {
                        augend.constant.new({ elements = { "let", "const" } }),
                        augend.hexcolor.new({ case = "lower" }),
                        augend.hexcolor.new({ case = "upper" }),
                    },
                    typescript = {
                        augend.constant.new({ elements = { "let", "const" } }),
                    },
                    css = {
                        augend.hexcolor.new({ case = "lower" }),
                        augend.hexcolor.new({ case = "upper" }),
                    },
                    markdown = {
                        augend.constant.new({
                            elements = { "[ ]", "[x]" },
                            word = false,
                            cyclic = true,
                        }),
                        augend.misc.alias.markdown_header,
                    },
                    json = {
                        augend.semver.alias.semver,
                    },
                    lua = {
                        augend.constant.new({
                            elements = { "and", "or" },
                            word = true,
                            cyclic = true,
                        }),
                    },
                    python = {
                        augend.constant.new({
                            elements = { "and", "or" },
                            word = true,
                            cyclic = true,
                        }),
                    },
                },
            }
        end,

        config = function(_, opts)
            for name, group in pairs(opts.groups) do
                if name ~= "default" then
                    vim.list_extend(group, opts.groups.default)
                end
            end
            require("dial.config").augends:register_group(opts.groups)
            vim.g.dials_by_ft = opts.dials_by_ft
        end,
    },
}
