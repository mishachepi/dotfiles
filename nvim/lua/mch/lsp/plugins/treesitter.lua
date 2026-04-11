-- nvim 0.12+ treesitter config
-- IMPORTANT: branch = "main" is required for nvim 0.12 compatibility
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile", "VeryLazy" },
	config = function()
		-- SteamOS has no /usr/include, tell gcc where brew glibc headers are
		local glibc_include = "/home/linuxbrew/.linuxbrew/opt/glibc/include"
		if vim.uv.fs_stat(glibc_include) and not vim.env.C_INCLUDE_PATH then
			vim.env.C_INCLUDE_PATH = glibc_include
		end

		local ts = require("nvim-treesitter")

		ts.setup({
			ensure_installed = {
				"python",
				"bash",
				"json",
				"yaml",
				"html",
				"css",
				"javascript",
				"typescript",
				"dockerfile",
				"rust",
				"gdscript",
			},
			highlight = { enable = true },
			indent = { enable = true },
		})

		-- Install missing parsers
		local installed = ts.get_installed()
		local installed_set = {}
		for _, lang in ipairs(installed) do
			installed_set[lang] = true
		end

		local ensure = {
			"python", "bash", "json", "yaml", "html", "css",
			"javascript", "typescript", "dockerfile", "rust", "gdscript",
		}
		local missing = {}
		for _, lang in ipairs(ensure) do
			if not installed_set[lang] then
				table.insert(missing, lang)
			end
		end

		if #missing > 0 then
			ts.install(missing)
		end
	end,
}
