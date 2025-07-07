local M = {}

function M.trash_file(file)
  file = file or vim.fn.expand("%:p")
  if file == "" or vim.fn.filereadable(file) == 0 then
    print("No valid file to trash (maybe you're in NvimTree or a non-file buffer?)")
    return
  end

  local cmd = "/usr/bin/trash-put " .. vim.fn.shellescape(file)
  local result = os.execute(cmd)

  if result == 0 then
    print("Moved to trash: " .. file)
    vim.cmd("bdelete!")  -- close buffer
  else
    print("Failed to move file to trash: " .. file)
  end
end

return M