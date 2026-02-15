return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/lazydev.nvim", ft = "lua", opts = {} },
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap
		local capabilities = cmp_nvim_lsp.default_capabilities()
		local servers = require("mch.lsp.servers").list
		local has_jinja_lsp = vim.fn.executable("jinja-lsp") == 1

		local function toggle_diagnostics(bufnr)
			bufnr = bufnr or 0
			local enabled = vim.diagnostic.is_enabled({ bufnr = bufnr })
			vim.diagnostic.enable(not enabled, { bufnr = bufnr })
			print("Diagnostics " .. (enabled and "disabled" or "enabled"))
		end

		-- Create the autocmd for LSP keybindings
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local client = ev.data and vim.lsp.get_client_by_id(ev.data.client_id) or nil
				if client and (client.name == "ts_ls" or client.name == "eslint") then
					client.server_capabilities.semanticTokensProvider = nil
				end

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, opts)
				keymap.set("n", "<leader>gd", function()
					vim.lsp.buf.definition()
				end, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "gh", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>sr", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>dd", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show workspace diagnostics"
				keymap.set("n", "<leader>dr", "<cmd>Telescope diagnostics<CR>", opts) -- show diagnostics for workspace

				opts.desc = "Diagnostics Line show"
				keymap.set("n", "<leader>df", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "<leader>dp", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, opts)
				keymap.set("n", "<leader>K", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "<leader>dn", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, opts)
				keymap.set("n", "<leader>J", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, opts)

				-- Yank diagnostics message
				keymap.set("n", "<leader>dy", function()
					local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
					if #diagnostics == 0 then
						print("No diagnostics on this line.")
						return
					end
					local messages = {}
					for _, diag in ipairs(diagnostics) do
						table.insert(messages, diag.message)
					end
					local result = table.concat(messages, "\n")
					vim.fn.setreg("+", result) -- Yank to clipboard
					print("Copied diagnostics to clipboard!")
				end, { desc = "Yank diagnostics message" })

				-- Toggle diagnostics visibility
				opts.desc = "Toggle diagnostics visibility"
				keymap.set("n", "<leader>dt", function()
					toggle_diagnostics(ev.buf)
				end, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>lr", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- Update diagnostic signs in the sign column using the new API
		local signs = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
		}

		vim.diagnostic.config({
			signs = {
				text = signs,
			},
		})

		local server_configs = {
			pyright = {
				handlers = {
					["textDocument/publishDiagnostics"] = function() end,
				},
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
						},
					},
				},
			},
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			},
			yamlls = {
				settings = {
					yaml = {
						schemas = {
							["https://json.schemastore.org/helmfile.json"] = "helmfile.yaml",
							["https://json.schemastore.org/chart.json"] = "Chart.yaml",
							["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.28.0-standalone-strict/all.json"] = {
								"*.k8s.yaml",
								"*.k8s.yml",
								"k8s/*.yaml",
								"k8s/*.yml",
							},
						},
						format = { enable = true },
						validate = true,
					},
				},
			},
			ts_ls = {
				workspace_required = true,
			},
			eslint = {
				workspace_required = true,
			},
			jinja_lsp = {
				filetypes = { "jinja", "jinja2" },
			},
		}

		local enabled_servers = {}
		for _, server_name in ipairs(servers) do
			if server_name ~= "jinja_lsp" or has_jinja_lsp then
				local config = vim.tbl_deep_extend("force", {}, server_configs[server_name] or {})
				config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
				vim.lsp.config(server_name, config)
				table.insert(enabled_servers, server_name)
			end
		end

		vim.lsp.enable(enabled_servers)
	end,
}
