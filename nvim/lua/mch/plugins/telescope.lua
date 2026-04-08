

return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	cmd = "Telescope",
	keys = {
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files in cwd" },
		{ "<D-s>", "<cmd>Telescope find_files<cr>", desc = "Find files in cwd" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Find recent files" },
		{ "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Find string in cwd" },
		{ "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor in cwd" },
		{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Find keymaps" },
		{ "<leader>fp", "<cmd>Telescope commands<cr>", desc = "Find commands" },
		{ "<leader>fx", "<cmd>Telescope diagnostics<cr>", desc = "Find diagnostics" },
		{
			"<leader>fn",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find Neovim files",
		},
		{
			"<leader>fd",
			function()
				require("telescope.builtin").lsp_document_symbols({
					symbols = {
						"method",
						"function",
						"class",
					},
					sorting_strategy = "ascending",
				})
			end,
			desc = "Find LSP Document Symbols",
		},
		{
			"<leader>fi",
			"<cmd>Telescope find_files find_command=rg,--files,--hidden,--no-ignore<cr>",
			desc = "Find ignored files",
		},
		{
			"<leader>fm",
			function()
				require("telescope.builtin").marks()
			end,
			desc = "Find existing marks",
		},
		{
			"<leader>f/",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
					sorting_strategy = "ascending",
				}))
			end,
			desc = "[F/] Find in current buffer",
		},
		{ "<leader>gh", "<cmd>GitHistoryFile<cr>", desc = "Find Git history for a file" },
		{ "<leader>gs", "<cmd>FullGitStatus<cr>", desc = "Find Git Status" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-c>"] = actions.delete_buffer, -- Close selected buffer
					},
					n = {
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-c>"] = actions.delete_buffer, -- Close selected buffer
					},
				},
			},
		})

		telescope.load_extension("fzf")
		-- GIT HISTORY SEARCH
		vim.api.nvim_create_user_command("GitHistoryFile", function()
			require("telescope.builtin").git_bcommits({
				layout_strategy = "horizontal",
				layout_config = {
					width = function(_, cols, _)
						return cols
					end,
					height = function(_, _, rows)
						return rows
					end,
					preview_cutoff = 0, -- Always show preview
					preview_width = 0.6, -- This works with horizontal layout
				},
			})
		end, {})

		-- GIT_STATUS PICKER WITH HORIZONTAL SPLIT
		vim.api.nvim_create_user_command("FullGitStatus", function()
			require("telescope.builtin").git_status({
				layout_strategy = "horizontal",
			})
		end, {})
	end,
}
