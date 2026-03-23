return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local term = require("toggleterm")
		local term_api = require("toggleterm.terminal")

		local function close_neo_tree()
			vim.cmd("silent! Neotree close")
		end

		local function close_all_toggleterms()
			local terminals = term_api.get_all()
			if not terminals then
				return
			end

			for _, toggleterm in pairs(terminals) do
				if toggleterm:is_open() then
					toggleterm:close()
				end
			end
		end

		term.setup({
			size = 50,
			open_mapping = [[<c-\>]],
			direction = "vertical",
			side = "right",
			on_open = close_neo_tree,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "neo-tree",
			callback = close_all_toggleterms,
		})

		vim.api.nvim_create_autocmd("TermOpen", {
			callback = function()
				vim.opt_local.list = false
			end,
		})

		vim.keymap.set("n", "<leader>tt", function()
			vim.cmd("ToggleTerm")
		end, { desc = "Toggle vertical terminal" })
	end,
}
