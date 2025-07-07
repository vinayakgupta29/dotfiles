return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {"nvim-tree/nvim-web-devicons" -- optional for icons
    },
    config = function()
        require("nvim-tree").setup({
            view = {
                width = 30,
                side = "left"
            },
            git = {
                enable = true
            },
            actions = {
                open_file = {
                    quit_on_open = true
                },
            change_dir = {
                    enable = true,
                    global = true,
                    restrict_above_cwd = true
                },
                use_system_clipboard = true,
            },
            on_attach = function(bufnr)
                local api = require("nvim-tree.api")

                -- Set all default mappings
                api.config.mappings.default_on_attach(bufnr)

                -- Add your custom mappings below (example: trash with 'd')
                vim.keymap.set('n', 'd', function()
                    local node = api.tree.get_node_under_cursor()
                    if node and node.absolute_path then
                        require("config.trash").trash_file(node.absolute_path)
                        api.tree.reload()
                    else
                        print("No file selected!")
                    end
                end, { desc = "Trash file with trash-put", buffer = bufnr, noremap = true, silent = true, nowait = true })
            end,
            renderer = {
                highlight_git = true,
                icons = {
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true
                    },
                    glyphs = {
                        default = "",
                        symlink = "",
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                            default = "",
                            open = "",
                            empty = "",
                            empty_open = "",
                            symlink = "",
                            symlink_open = ""
                        },
                        git = { -- ✅ This goes here
                            unstaged = "",
                            staged = "✓",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "★",
                            deleted = "",
                            ignored = "◌"
                        },
                    }
                }
            }
        })
    end
}
