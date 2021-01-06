local plugin = {name = "bufferline"}
Plugins[plugin.name] = plugin

local colors = require "bufferline/colors"

local settings = {
	show_buffer_close_icons = false,
	separator_style = {"▕", "▊"},
	close_icon = '',
	modified_icon = "",
	tab_size = 0,
	enforce_regular_tabs = false
}

local function getStatusNumbers()
	local error = vim.lsp.diagnostic.get_count(0, [[Error]])
	local warning = vim.lsp.diagnostic.get_count(0, [[Warning]])
	local information = vim.lsp.diagnostic.get_count(0, [[Information]])
	local hint = vim.lsp.diagnostic.get_count(0, [[Hint]])
	return {error, warning, information, hint}
end

function _G.nvim_copperline()
	-- @type string
	local bufferline = _G.nvim_bufferline()
	bufferline = string.sub(bufferline, 1, #bufferline - 16)
	bufferline = bufferline
	local status = getStatusNumbers()
	bufferline = bufferline .. '%#TablineSeparator# '
	if status[4] ~= 0 then
		bufferline = bufferline .. "%#TablineHint# ﬤ " .. status[4]
	end
	if status[3] ~= 0 then
		bufferline = bufferline .. "%#TablineInfo#  " .. status[3]
	end
	if status[2] ~= 0 then
		bufferline = bufferline .. "%#TablineWarning#  " .. status[2]
	end
	if status[1] ~= 0 then
		bufferline = bufferline .. "%#TablineError#  " .. status[1]
	end
	if status[1] + status[2] + status[3] + status[4] == 0 then
		bufferline = bufferline .. "%#TablineSuccess# "
	end
	return bufferline .. " "
end

function plugin.settings()
	local c = {
		fill_bg = colors.get_hex("TabLineFill", "bg"),
		selected_bg = colors.get_hex("Normal", "bg"),
		selected_fg = colors.get_hex("Ignore", "fg"),
		selected_sign = colors.get_hex("InfoMsg", "fg"),
		visible_bg = colors.get_hex("Normal", "bg"),
		visible_fg = colors.get_hex("StatusLine", "fg"),
		visible_sign = colors.get_hex("StatusLine", "fg"),
		inactive_bg = colors.get_hex("ColorColumn", "bg"),
		inactive_fg = colors.get_hex("Comment", "fg"),
		inactive_sign = colors.get_hex("StatusLineNC", "fg"),

		red = colors.get_hex("Error", "fg"),
		orange = colors.get_hex("Warning", "fg"),
		green = colors.get_hex("String", "fg"),
		purple = colors.get_hex("Keyword", "fg"),
	}

	local pick = "bold"
	require("bufferline").setup{
		options = settings,
		highlights = {
			fill = {
				guibg = c.fill_bg
			},
			background = {
				guifg = c.inactive_fg,
				guibg = c.inactive_bg
			},
			tab = {
				guifg = c.inactive_fg,
				guibg = c.selected_bg
			},
			tab_selected = {
				guifg = c.selected_sign,
				guibg = c.selected_bg
			},
			buffer_visible = {
				guifg = c.visible_fg,
				guibg = c.visible_bg
			},
			buffer_selected = {
				guifg = c.selected_fg,
				guibg = c.selected_bg,
				gui = ""
			},
			indicator_selected = {
				guifg = c.selected_sign,
				guibg = c.selected_bg
			},
			separator = {
				guifg = c.fill_bg,
				guibg = c.selected_bg
			},
			separator_selected = {
				guifg = c.fill_bg,
				guibg = c.selected_bg
			},
			modified = {
				guifg = c.red,
				guibg = c.inactive_bg
			},
			modified_visible = {
				guifg = c.orange,
				guibg = c.visible_bg
			},
			modified_selected = {
				guifg = c.green,
				guibg = c.selected_bg
			},
			pick_selected = {
				guifg = c.inactive_fg,
				guibg = c.selected_bg,
				gui = pick
			},
			pick_visible = {
				guifg = c.orange,
				guibg = c.visible_bg,
				gui = pick
			},
			pick = {
				guifg = c.red,
				guibg = c.inactive_bg,
				gui = pick
			}
		}
	}

	vim.o.tabline = "%!v:lua.nvim_copperline()"
end

function plugin.keybinds()
	K.group([[Move between buffers using nvim-bufferline]], function()
		K.n("<C-j>", "<cmd>BufferLineCyclePrev<CR>")
		K.n("<C-k>", "<cmd>BufferLineCycleNext<CR>")
		K.sp("J", "<cmd>BufferLineMovePrev<CR>")
		K.sp("K", "<cmd>BufferLineMoveNext<CR>")
		K.n("<CR>", "<cmd>BufferLinePick<CR>")
	end)
end

return function()
	Plugins.bufferline.settings()
	K.plugin(Plugins.bufferline)
end
