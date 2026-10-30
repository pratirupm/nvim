local M = {}

local api = vim.api
local get_opt = api.nvim_get_option_value
local cur_buf = api.nvim_get_current_buf
local buf_name = api.nvim_buf_get_name
local get_hl = api.nvim_get_hl
local strep = string.rep

local function filename(str)
  return str:match "([^/\\]+)[/\\]*$"
end

local function new_hl(group1, group2)
  local fg = get_hl(0, { name = group1 }).fg
  local bg = get_hl(0, { name = "Tb" .. group2 }).bg
  api.nvim_set_hl(0, group1 .. group2, { fg = fg, bg = bg })
  return "%#" .. group1 .. group2 .. "#"
end

local function gen_unique_name(name, index)
  for i2, nr2 in ipairs(vim.t.bufs) do
    local filepath = filename(buf_name(nr2))
    if index ~= i2 and filepath == name then
      return vim.fn.fnamemodify(buf_name(vim.t.bufs[index]), ":h:t") .. "/" .. name
    end
  end
end

local function style_buf(nr, i, w)
  local utils = require "nvchad.tabufline.utils"
  local txt = utils.txt
  local btn = utils.btn
  local icon = "󰈚 "
  local is_curbuf = cur_buf() == nr
  local tbHlName = "BufO" .. (is_curbuf and "n" or "ff")
  local icon_hl = new_hl("DevIconDefault", tbHlName)

  local name = filename(buf_name(nr))
  name = name and (gen_unique_name(name, i) or name) or " No Name "

  if name ~= " No Name " then
    local devicon, devicon_hl = require("nvim-web-devicons").get_icon(name)

    if devicon then
      icon = " " .. devicon .. " "
      icon_hl = new_hl(devicon_hl, tbHlName)
    end
  end

  -- Keep the original tab width, but leave the close-button slot empty.
  local pad = math.floor((w - #name - 5) / 2)
  pad = pad <= 0 and 1 or pad

  local maxname_len = w - 5
  name = string.sub(name, 1, maxname_len - 2) .. (#name > maxname_len and ".." or "")
  name = txt(name, tbHlName)

  name = strep(" ", pad - 1) .. (icon_hl .. icon .. name) .. strep(" ", pad - 1)

  local mod = get_opt("mod", { buf = nr })
  local cur_mod = get_opt("mod", { buf = 0 })
  local trailing

  if is_curbuf then
    trailing = cur_mod and txt("  ", "BufOnModified") or "   "
  else
    trailing = mod and txt("  ", "BufOffModified") or "   "
  end

  name = btn(name, nil, "GoToBuf", nr)
  return txt(name .. trailing, tbHlName)
end

function M.setup()
  local utils = require "nvchad.tabufline.utils"
  if utils._no_close_icons then
    return
  end

  utils._no_close_icons = true
  utils.style_buf = style_buf
end

return M
