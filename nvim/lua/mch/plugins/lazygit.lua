return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>lgg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
		{ "<leader>lgh", "<cmd>LazyGitFilter<cr>", desc = "LazyGit commit history" },
	},
}
