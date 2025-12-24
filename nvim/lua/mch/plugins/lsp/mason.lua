return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- Python tools
				"ruff", -- Linter and formatter (replaces black, isort, flake8)

				-- YAML/Ansible/Kubernetes tools
				"yamllint", -- YAML linter
				"ansible-lint", -- Ansible playbook linter
				"kube-linter", -- Kubernetes manifest linter

				-- General utilities
				"jq", -- JSON processor

				-- Lua (for Neovim config editing)
				"stylua", -- Lua formatter
			},
			-- Optional tools (install manually via :Mason when needed):
			-- prettier, eslint_d, golines, jsonlint, etc.
		})
	end,
}
