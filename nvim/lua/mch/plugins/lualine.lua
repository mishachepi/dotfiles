return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")

		local function isRecording()
			local reg = vim.fn.reg_recording()
			if reg == "" then
				return ""
			end
			return "@[" .. reg .. "]"
		end

		lualine.setup({
			options = {
				theme = "auto",
			},
			sections = {
				lualine_c = {
					"filename",
					{ isRecording },
				},
				lualine_x = {
					{
						"filetype",
						icon_only = true,
					},
				},
			},
		})
	end,
}
