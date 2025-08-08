return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	event = "VeryLazy",
	cmd = "Telescope",
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

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		local telescope_builtin = require("telescope.builtin")
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })

		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
		keymap.set("n", "<leader>fx", "<cmd>Telescope diagnostics<cr>", { desc = "Find diagnostics" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" })

		keymap.set("n", "<leader>fn", function()
			telescope_builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Find Neovim files" })

		-- SEARCH FOR SYMBOLS IN CURRENT FILE
		local function filtered_document_symbols()
			telescope_builtin.lsp_document_symbols({
				symbols = {
					"method",
					"function",
					"class",
					--"constant",
				},
				sorting_strategy = "ascending", -- Ensures order follows LSP
			})
		end
		keymap.set(
			"n",
			"<leader>fd",
			filtered_document_symbols,
			{ noremap = true, silent = true, desc = "Find LSP Document Symbols" }
		)
		-- SEARCH FILES INLCUDING THOSE IN GITIGNORE
		keymap.set(
			"n",
			"<leader>fi",
			"<cmd>Telescope find_files find_command=fd,--type,f,--hidden,--no-ignore<cr>",
			{ desc = "Find ignored files" }
		)

		-- SEARCH EXISTING MARKS
		keymap.set("n", "<leader>fm", function()
			telescope_builtin.marks()
		end, { desc = "Find existing marks" })

		-- GREP FILES WITH RIPGREP
		require("mch.plugins.telescope.multigrep").setup()

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			telescope_builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
				sorting_strategy = "ascending", -- Keeps order as in the buffer
			}))
		end, { desc = "[/] Find in current buffer" })

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
		keymap.set("n", "<leader>gh", "<cmd>GitHistoryFile<cr>", { desc = "Find Git history for a file" })

		-- GIT_STATUS PICKER WITH HORIZONTAL SPLIT
		vim.api.nvim_create_user_command("FullGitStatus", function()
			require("telescope.builtin").git_status({
				layout_strategy = "horizontal",
			})
		end, {})
		keymap.set("n", "<leader>gs", "<cmd>FullGitStatus<cr>", { desc = "Find Git Status" })
	end,
}
