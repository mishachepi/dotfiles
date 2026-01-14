return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")
		local servers = require("mch.lsp.servers").list

		mason.setup({
			PATH = "prepend",
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = servers,
			automatic_enable = false,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- YAML/Ansible/Kubernetes tools
				"yamllint", -- YAML linter
				"ansible-lint", -- Ansible playbook linter
				"kube-linter", -- Kubernetes manifest linter

				-- General utilities
				"jq", -- JSON processor
				"prettier", -- JS/TS/HTML/CSS/JSON formatter
				"taplo", -- TOML formatter
				"pyproject-fmt", -- TOML formatter for pyproject

				-- Lua (for Neovim config editing)
				"stylua", -- Lua formatter
			},
			-- Optional tools (install manually via :Mason when needed):
			-- prettier, eslint_d, golines, jsonlint, etc.
		})
	end,
}
