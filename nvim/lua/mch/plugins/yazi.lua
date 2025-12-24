local function open_yazi_at_buffer_dir()
	local path = vim.fn.expand("%:p")
	local dir = path ~= "" and vim.fn.fnamemodify(path, ":h") or vim.fn.getcwd()
	local old_cwd = vim.fn.getcwd()

	vim.cmd("lcd " .. dir)
	vim.cmd("Yazi")
	vim.cmd("lcd " .. old_cwd)
end

return {
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>ey",
				open_yazi_at_buffer_dir,
				desc = "Open yazi at buffer dir",
			},
			{
				-- Open in the current working directory
				"<leader>cw",
				"<cmd>Yazi cwd<cr>",
				desc = "Open the file manager in nvim's working directory",
			},
			{
				"<leader>yr",
				"<cmd>Yazi toggle<cr>",
				desc = "Yazi resume last session",
			},
		},
		---@type YaziConfig
		opts = {
			-- if you want to open yazi instead of netrw, see below for more info
			open_for_directories = false,
			keymaps = {
				show_help = "<f1>",
			},
		},
		config = function(_, opts)
			require("yazi").setup(opts)
			vim.api.nvim_create_user_command("YaziHere", open_yazi_at_buffer_dir, { desc = "Open yazi at buffer dir" })
		end,
	},
}
