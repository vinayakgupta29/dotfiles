local M = {}

local term_bufnr = nil
local term_winid = nil

function M.toggle_split_shell()
  -- If terminal is already open, close it
  if term_winid and vim.api.nvim_win_is_valid(term_winid) then
    vim.api.nvim_win_close(term_winid, true)
    term_winid = nil
    term_bufnr = nil
  else
    -- Create new terminal buffer
    term_bufnr = vim.api.nvim_create_buf(false, true)

    local total_lines = vim.o.lines
    local height = math.floor(total_lines * 0.45)

    -- Save current window to return focus later
    local cur_win = vim.api.nvim_get_current_win()

    -- Open horizontal split with height
    vim.cmd(height .. "split")
    term_winid = vim.api.nvim_get_current_win()

    -- Set buffer to terminal buffer
    vim.api.nvim_win_set_buf(term_winid, term_bufnr)

    -- Optional: minimal style
    vim.wo[term_winid].number = false
    vim.wo[term_winid].relativenumber = false

    -- Hide the default statusline in this terminal buffer
vim.api.nvim_win_set_option(term_winid, "statusline", "")

    -- Start terminal
    vim.fn.termopen("fish")

    -- Enter insert mode
    vim.cmd("startinsert")

    -- <Esc> to close terminal window
    vim.api.nvim_buf_set_keymap(term_bufnr, "t", "<Esc>", "<C-\\><C-n>:bd!<CR>", { noremap = true, silent = true })

    -- Restore previous window focus
    vim.api.nvim_set_current_win(cur_win)
  end
end

return M

