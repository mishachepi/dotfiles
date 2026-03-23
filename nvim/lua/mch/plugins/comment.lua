return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	keys = {
		{ "<leader>/", "gcc", mode = "n", remap = true, desc = "Toggle comment" },
		{ "<leader>/", "gc", mode = "v", remap = true, desc = "Toggle comment" },
	},
	config = function()
		local comment = require("Comment")
		local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

		comment.setup({
			pre_hook = ts_context_commentstring.create_pre_hook(),
		})
	end,
}
