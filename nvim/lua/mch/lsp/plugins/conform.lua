--- formatter
return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local has_djlint = vim.fn.executable("djlint") == 1

		conform.formatters.ruff_format = {
			command = "ruff",
			args = { "format", "--stdin-filename", "$FILENAME", "-" },
			stdin = true,
		}

		if has_djlint then
			conform.formatters.djlint = {
				command = "djlint",
				args = { "--profile=jinja", "--reformat", "-" },
				stdin = true,
			}
		end

		local formatters_by_ft = {
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			svelte = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			graphql = { "prettier" },
			liquid = { "prettier" },
			toml = function(bufnr)
				local name = vim.api.nvim_buf_get_name(bufnr)
				if vim.fn.fnamemodify(name, ":t") == "pyproject.toml" then
					return { "pyproject-fmt" }
				end
				return { "taplo" }
			end,
			lua = { "stylua" },
			python = { "ruff_format" },
		}
		if has_djlint then
			formatters_by_ft.jinja = { "djlint" }
			formatters_by_ft.jinja2 = { "djlint" }
		end

		conform.setup({
			formatters_by_ft = formatters_by_ft,

			-- format_on_save = {
			-- 	lsp_fallback = true,
			-- 	async = false,
			-- 	timeout_ms = 1000,
			-- },
		})

		vim.keymap.set({ "n", "v" }, "<leader>lf", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
