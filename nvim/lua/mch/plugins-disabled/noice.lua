return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		lsp = {
			progress = {
				enabled = false, -- disable LSP progress messages
			},
			hover = {
				enabled = true, -- enable hover messages
			},
			signature = {
				enabled = true, -- enable signature help
			},
		},
		routes = {
			-- Hide "No information available"
			{
				filter = { event = "notify", find = "[Scratch]" },
				opts = { skip = true },
			},
			{
				filter = { event = "notify", find = "[Prompt]" },
				opts = { skip = true },
			},
			{
				filter = { event = "notify", find = "No information available" },
				opts = { skip = true },
			},
			-- Suppress indents
			{
				filter = {
					event = "msg_show",
					kind = "",
					find = "<ed",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "msg_show",
					kind = "",
					find = ">ed",
				},
				opts = { skip = true },
			},
			-- Suppress yanked messages
			-- {
			-- 	filter = {
			-- 		event = "msg_show",
			-- 		kind = "",
			-- 		find = ", job_id",
			-- 	},
			-- 	opts = { skip = true },
			-- },
			-- Suppress yanked messages
			-- {
			-- 	filter = {
			-- 		event = "msg_show",
			-- 		kind = "",
			-- 		find = " lines yanked",
			-- 	},
			-- 	opts = { skip = true },
			-- },
			-- Suppress undo/redo messages
			{
				filter = {
					event = "msg_show",
					kind = "",
					find = "change;",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "msg_show",
					kind = "",
					find = "more line",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "msg_show",
					kind = "",
					find = "line less",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "msg_show",
					kind = "",
					find = "fewer line",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "msg_show",
					kind = "",
					find = "Already at oldest",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "msg_show",
					kind = "",
					find = "written",
				},
				opts = { skip = true },
			},
		},
		presets = {
			command_palette = true, -- position the command line in the status line area
			lsp_doc_border = true,
		},
		-- Key mapping to dismiss notifications
		vim.keymap.set("n", "<leader><Esc>", function()
			require("noice").cmd("dismiss")
		end, { noremap = true, silent = true, desc = "Dismiss all notifications" }),
		cmdline = {
			view = "cmdline_popup", -- включаем pop-up режим
		  },
		  views = {
			cmdline_popup = {
			  position = {
				row = "95%",
				col = "50%",
			  },
			  size = {
				width = 60,
				height = "auto",
			  },
			  border = {
				style = "rounded",
				padding = { 0, 1 },
			  },
			  win_options = {
				winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
			  },
			},
		  },
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
}
