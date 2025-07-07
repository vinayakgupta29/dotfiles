local M = {}

local float_bufnr = nil
local float_winid = nil

function M.toggle_floating_shell()
  if float_winid and vim.api.nvim_win_is_valid(float_winid) then
    -- If floating window exists and is open, close it
    vim.api.nvim_win_close(float_winid, true)
    float_winid = nil
    float_bufnr = nil
  else
    -- Otherwise create it
    float_bufnr = vim.api.nvim_create_buf(false, true)

    local width = math.floor(vim.o.columns * 0.6)
    local height = math.floor(vim.o.lines * 0.3)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local opts = {
      style = "minimal",
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      border = "rounded",
    }

    float_winid = vim.api.nvim_open_win(float_bufnr, true, opts)

    -- Start terminal with user's default shell
    vim.fn.termopen("fish")

    -- Enter insert mode immediately
    vim.cmd("startinsert")

    -- Map <Esc> to close floating terminal as well
    vim.api.nvim_buf_set_keymap(float_bufnr, "t", "<Esc>", "<C-\\><C-n>:bd!<CR>", { noremap = true, silent = true })
  end
end

return M

