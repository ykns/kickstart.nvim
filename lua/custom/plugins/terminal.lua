---@type { [number]: number }
local terminals = {}
local prevBuf = -1

local create_terminal_buf = function()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_set_current_buf(buf)
  vim.cmd.terminal()
  vim.cmd.startinsert()
  return buf
end

local toggle_terminal_buffer = function(opts)
  local terminalBuf = terminals[opts.index]
  if terminalBuf == nil or not vim.api.nvim_buf_is_valid(terminalBuf) then
    prevBuf = vim.api.nvim_get_current_buf()
    -- create new terminal buffer
    terminals[opts.index] = create_terminal_buf()
  else
    local currentBuf = vim.api.nvim_get_current_buf()
    if currentBuf == terminalBuf then
      -- go back to the previous buffer
      if vim.api.nvim_buf_is_valid(prevBuf) then
        vim.api.nvim_set_current_buf(prevBuf)
      else
        -- edge case: after restore, previous buffer is no longer valid
        -- so we show telescope recent buffers
        require('telescope.builtin').buffers()
      end
    else
      prevBuf = currentBuf
      -- switch to terminal buffer
      vim.api.nvim_set_current_buf(terminalBuf)
    end
  end
end

vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')
vim.keymap.set({ 'n', 't' }, '<F11>', function() toggle_terminal_buffer { index = vim.v.count } end, { desc = 'Toggle term buffer' })

return {}
