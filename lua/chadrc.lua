-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "aquarium",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },

	hl_add = {
		TreesitterContext = { bg = "one_bg2" },
		TreesitterContextLineNumber = { fg = "yellow", bg = "one_bg2" },
		TreesitterContextBottom = { underline = true, sp = "grey" },
	},
}

M.term = {
  float = {
    width = 0.75,
    height = 0.65,
    row = 0.15,
    col = 0.125,
  },
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }

return M
