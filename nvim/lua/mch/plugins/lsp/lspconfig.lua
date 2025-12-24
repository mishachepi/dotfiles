return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason-lspconfig.nvim",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
	local lspconfig = require("lspconfig")
	local util = require("lspconfig.util")
	local mason_lspconfig = require("mason-lspconfig")
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local keymap = vim.keymap
	local capabilities = cmp_nvim_lsp.default_capabilities()
	local function toggle_diagnostics(bufnr)
		bufnr = bufnr or 0
		local disabled = (vim.diagnostic.is_disabled and vim.diagnostic.is_disabled(bufnr))
			or vim.b[bufnr].diagnostics_disabled
		if disabled then
			vim.diagnostic.enable(bufnr)
			vim.b[bufnr].diagnostics_disabled = false
			print("Diagnostics enabled")
		else
			vim.diagnostic.disable(bufnr)
			vim.b[bufnr].diagnostics_disabled = true
			print("Diagnostics disabled")
		end
	end

	_G.ToggleDiagnostics = toggle_diagnostics

	-- Create the autocmd for LSP keybindings
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
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

	-- Define custom root dir detection
	local function get_python_root(startpath)
		if type(startpath) == "number" then
			startpath = vim.api.nvim_buf_get_name(startpath)
		end
		if not startpath or startpath == "" then
			startpath = vim.loop.cwd()
		end
		local git_dir = vim.fs.find({ ".git" }, { path = startpath, upward = true })[1]
		local project_dir = vim.fs.find(
			{ "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt" },
			{ path = startpath, upward = true }
		)[1]
		local root = git_dir or project_dir or startpath
		return root and vim.fs.dirname(root) or nil
	end

	local servers = {
		yamlls = {},
		ansiblels = {},
		bashls = {},
		cssls = {},
		eslint = { filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" } },
		graphql = {},
		html = {},
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
		puppet = {},
		pyright = {
			root_dir = get_python_root,
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
		ruff = {
			on_attach = function(client)
				client.server_capabilities.hoverProvider = false
				client.server_capabilities.definitionProvider = false
				client.server_capabilities.referencesProvider = false
				client.server_capabilities.renameProvider = false
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.codeActionProvider = false
			end,
		},
		svelte = {
			on_attach = function(client)
				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
					end,
				})
			end,
		},
	}

	mason_lspconfig.setup({
		ensure_installed = vim.tbl_keys(servers),
		automatic_installation = true,
	})

	local function setup_server(server_name)
		local server = servers[server_name] or {}
		server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
		if vim.lsp and vim.lsp.config then
			vim.lsp.config(server_name, server)
			vim.lsp.enable(server_name)
		else
			lspconfig[server_name].setup(server)
		end
	end

	if mason_lspconfig.setup_handlers then
		mason_lspconfig.setup_handlers({ setup_server })
	else
		for server_name in pairs(servers) do
			setup_server(server_name)
		end
	end
	end,
}
