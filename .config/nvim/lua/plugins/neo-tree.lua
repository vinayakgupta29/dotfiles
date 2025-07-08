-- ~/.config/nvim/lua/plugins/neotree.lua

local opts = {
  options = {
    mode = "buffers", -- show each buffer as a tab
    numbers = "none",
    diagnostics = "nvim_lsp",
    show_buffer_close_icons = true,
    show_close_icon = false,
    separator_style = "slant", -- or "thin" / "padded_slant"
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        text_align = "center",
        separator = true,
      },
    },
  },
  sources = { "filesystem", "buffers", "git_status" },
  open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
  close_if_last_window = true,
  popup_border_style = "rounded",
  filesystem = {
    renderer = {
      highlight_git = true,
      highlight_opened_files = "name", -- highlight opened files by name
      highlight_modified = "icon", -- highlight modified files by icon
      indent_markers = {
        enable = true,
      },
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
      },
      -- Here we override the 'name' highlight for executable files
      name = function(state, node)
        local hl_name = "NeoTreeFileName"
        if node.type == "file" and node.data and node.data.is_executable then
          hl_name = "NeoTreeExecutable"
        end
        return {
          text = node.name,
          highlight = hl_name,
        }
      end,
    },
    bind_to_cwd = false,
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
  },
  window = {
    mappings = {
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["o"] = "open",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["C"] = "close_node",
            ["."] = "set_root",
            ["H"] = "toggle_hidden",
            ["R"] = "refresh",
            ["/"] = "fuzzy_finder",
            ["f"] = "filter_on_submit",
            ["<c-x>"] = "clear_filter",
            ["a"] = "add",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["P"] = function(state)
              local node = state.tree:get_node()
              local relpath = vim.fn.fnamemodify(node.path, ":.")
              vim.fn.setreg("+", relpath)
              vim.notify("Copied relative path: " .. relpath)
            end,
          },
  },
  default_component_configs = {
    indent = {
      with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    git_status = {
      symbols = {
        unstaged  = "U",  
        staged    = "✓",
        unmerged  = "",
        renamed   = "➜",
        untracked = "★",
        deleted   = "",
        ignored   = "",
     },
    },
  },
}

return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim", 
        "nvim-lua/plenary.nvim", 
        "nvim-tree/nvim-web-devicons"
    },
    opts = opts,
    config = function()
        require("neo-tree").setup(opts)

        -- ✅ Set git + folder highlights
        local highlights = {
            NeoTreeGitStaged = {
                fg = "#81b88b"
            },
            NeoTreeGitUnstaged = {
                fg = "#e2c08d"
            },
            NeoTreeGitUntracked = {
                fg = "#73c991"
            },
            NeoTreeGitIgnored = {
                fg = "#8c8c8c"
            },
            NeoTreeGitRenamed = {
                fg = "#73c991"
            },
            NeoTreeGitDeleted = {
                fg = "#f97583"
            },
            NeoTreeGitConflict = {
                fg = "#e4676b"
            },
            NeoTreeDirectoryName = {
                fg = "#dadada"
            }
        }

        for group, hl in pairs(highlights) do
            vim.api.nvim_set_hl(0, group, hl)
        end
    end
}
