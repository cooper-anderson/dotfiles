return function()
	local config = vim.fn["stdpath"]("config") .. "/plugin/markdownpreview"
	vim.g.mkdp_markdown_css = config .. "/markdown.css"
	vim.g.mkdp_highlight_css = config .. "/markdown_dark.css"
	vim.g.mkdp_refresh_slow = true
end
