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

		local ensure_lsp = servers
		if mason_lspconfig.get_available_servers then
			local available = mason_lspconfig.get_available_servers()
			local allowed = {}
			for _, name in ipairs(available) do
				allowed[name] = true
			end
			ensure_lsp = vim.tbl_filter(function(name)
				return allowed[name] == true
			end, servers)
		end

		mason_lspconfig.setup({ ensure_installed = ensure_lsp, automatic_enable = false })

		local ensure_tools = {
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

				-- Templates (optional; only if available in Mason registry)
				-- "djlint",
		}

		local ok_registry, registry = pcall(require, "mason-registry")
		if ok_registry and registry.has_package and registry.has_package("djlint") then
			table.insert(ensure_tools, "djlint") -- Django/Jinja/Handlebars template formatter/linter
		end

		mason_tool_installer.setup({
			ensure_installed = ensure_tools,
			-- Optional tools (install manually via :Mason when needed):
			-- prettier, eslint_d, golines, jsonlint, etc.
		})
	end,
}
