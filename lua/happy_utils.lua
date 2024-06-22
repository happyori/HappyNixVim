_G.HappyUtils = {}

function HappyUtils:is_linux()
  return vim.fn.has("unix") == 1
end

function HappyUtils:is_apple()
  return vim.fn.has("mac") == 1
end

function HappyUtils:is_win()
  return vim.fn.has("windows") == 1
end

function HappyUtils:is_neovide()
  return vim.g.neovide
end

function HappyUtils.close_buffer()
  local success, bdModule = pcall(require, "mini.bufremove")
  if not success then
    vim.notify("Cannot remove buffer as mini.bufremove is not installed")
    return
  end
  if bdModule == nil then
    vim.notify("Buffer remove module not found")
    return
  end
  local bd = bdModule.delete

  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname(0)), "&Yes\n&No\n&Cancel")
    if choice == 1 then
      vim.cmd.write()
      bd(0)
    elseif choice == 2 then
      bd(0, true)
    end
  else
    bd(0)
  end
end

function HappyUtils:inspect_globals()
  local globals = vim.g
  local result = ''
  for key, value in pairs(globals) do
    result = result + key + ":" + value + "\n"
  end

  vim.inspect(result)
end

function HappyUtils:auto_indent(row)
  local indent = require("nvim-treesitter.indent").get_indent(row)
  local indent_char = vim.bo.expandtab and " " or "\t"
  if indent == 0 or vim.fn.mode() ~= "i" then
    return
  end
  local chars = string.rep(indent_char, indent)

  vim.api.nvim_put({ chars }, "c", false, true)
end

function HappyUtils.move_to_start()
  local current_pos = vim.fn.getcurpos()[3]
  if vim.fn.getline("."):find("%w") == nil then
    return vim.cmd("normal! 0")
  end
  vim.cmd("normal! ^") -- Move to first non-blank character
  local pos = vim.fn.getcurpos()
  local new_col = pos[3]
  local row = pos[2]
  if current_pos == new_col then
    if new_col == 1 then
      HappyUtils:auto_indent(row)
    else
      vim.cmd("normal! 0")
    end
  end
end

function HappyUtils.move_to_end()
  local row = vim.fn.getcurpos()[2]
  vim.fn.cursor({ row, 9999999999999 })
  if vim.fn.getcurpos()[3] == 1 then
    HappyUtils:auto_indent(row)
  end
end
