return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

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
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

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
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>ds", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
				keymap.set("n", "<leader>K", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
				keymap.set("n", "<leader>J", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

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
				keymap.set(
					"n",
					"<leader>dt",
					":lua ToggleDiagnostics()<CR>",
					{ noremap = true, silent = true, desc = "Toggle diagnostics visibility" }
				)
				local diagnostics_visible = true
				function ToggleDiagnostics()
					diagnostics_visible = not diagnostics_visible
					if diagnostics_visible then
						vim.diagnostic.enable(true) -- Enable diagnostics for the current buffer
						print("Diagnostics enabled")
					else
						vim.diagnostic.enable(false) -- Disable diagnostics for the current buffer
						print("Diagnostics disabled")
					end
				end

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>dr", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,

			["yamlls"] = function()
				require("lspconfig").yamlls.setup({
				  capabilities = capabilities,
				  settings = {
					yaml = {
					  schemaStore = {
						enable = true,
						url = "https://www.schemastore.org/api/json/catalog.json",
					  },
					  schemas = {
						["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
						["https://json.schemastore.org/kustomization.json"] = "kustomization.yaml",
					  },
					  validate = true,
					},
				  },
				})
			  end,

			["bashls"] = function()
      require("lspconfig").bashls.setup({
        capabilities = capabilities,
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
      })
			  end,

			-- ["eslint"] = function()
			-- 	-- configure ESLint server
			-- 	lspconfig["eslint"].setup({
			-- 		capabilities = capabilities,
			-- 		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
			-- 		on_attach = function(client, bufnr)
			-- 			vim.api.nvim_create_autocmd("BufWritePre", {
			-- 				buffer = bufnr,
			-- 				command = "EslintFixAll", -- Auto-fix on save
			-- 			})
			-- 		end,
			-- 	})
			-- end,

			["graphql"] = function()
			  -- configure graphql language server
			  lspconfig["graphql"].setup({
			    capabilities = capabilities,
			    filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
			  })
			end,

			-- ["lua_ls"] = function()
			-- 	-- configure lua server (with special settings)
			-- 	lspconfig["lua_ls"].setup({
			-- 		capabilities = capabilities,
			-- 		settings = {
			-- 			Lua = {
			-- 				-- make the language server recognize "vim" global
			-- 				diagnostics = {
			-- 					globals = { "vim" },
			-- 				},
			-- 				completion = {
			-- 					callSnippet = "Replace",
			-- 				},
			-- 			},
			-- 		},
			-- 	})
			-- end,

		})
	end,
}
