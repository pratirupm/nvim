local api = vim.api

local M = {}

local id = "mainTerm"
local opts = { pos = "sp", id = id, size = 0.3 }

local function find_entry()
  for key, entry in pairs(vim.g.nvchad_terms or {}) do
    if entry.id == id then
      return key, entry
    end
  end
end

local function clear_entry(key)
  if key and vim.g.nvchad_terms then
    vim.g.nvchad_terms[key] = nil
  end
end

-- Replace the terminal buffer instead of closing the last window (E444).
local function fallback_buffer()
  local alternate = vim.fn.bufnr "#"
  if alternate ~= -1 and api.nvim_buf_is_valid(alternate) and vim.bo[alternate].buftype == "" then
    return alternate
  end

  for _, buf in ipairs(api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and vim.bo[buf].buftype == "" then
      return buf
    end
  end

  return api.nvim_create_buf(true, false)
end

local function hide_last_window(win)
  api.nvim_win_set_buf(win, fallback_buffer())
end

local function close_window(entry, win)
  entry.win = win
  local tab = api.nvim_win_get_tabpage(win)
  local floating = api.nvim_win_get_config(win).relative ~= ""

  if floating or #api.nvim_tabpage_list_wins(tab) > 1 then
    api.nvim_win_close(win, true)
  else
    hide_last_window(win)
  end
end

local function focus_window(win)
  local tab = api.nvim_win_get_tabpage(win)
  if api.nvim_get_current_tabpage() ~= tab then
    api.nvim_set_current_tabpage(tab)
  end
  api.nvim_set_current_win(win)
end

function M.toggle()
  local key, entry = find_entry()
  if entry and not api.nvim_buf_is_valid(entry.buf) then
    clear_entry(key)
    entry = nil
  end

  if entry then
    local windows = vim.fn.win_findbuf(entry.buf)
    if #windows > 0 then
      local current_tab = api.nvim_get_current_tabpage()
      local current_win

      for _, win in ipairs(windows) do
        if api.nvim_win_get_tabpage(win) == current_tab then
          current_win = win
          break
        end
      end

      if current_win then
        close_window(entry, current_win)
      else
        focus_window(windows[1])
      end
      return
    end
  end

  require("nvchad.term").toggle(opts)
end

function M.setup()
  local map = vim.keymap.set
  local del = vim.keymap.del

  pcall(del, "n", "<leader>h")
  pcall(del, "n", "<leader>v")
  pcall(del, { "n", "t" }, "<A-h>")
  pcall(del, { "n", "t" }, "<A-v>")
  pcall(del, { "n", "t" }, "<A-i>")

  map("n", "<leader>tt", M.toggle, { desc = "Toggle terminal" })
  map("t", "<C-t>", M.toggle, { desc = "Toggle terminal" })
  map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
end

return M
