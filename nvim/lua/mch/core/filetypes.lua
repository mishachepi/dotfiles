-- Filetype detection and per-filetype defaults

-- Jinja2 templates
vim.filetype.add({
	extension = {
		j2 = "jinja",
		jinja = "jinja",
		jinja2 = "jinja",
	},
	pattern = {
		[".*%.html%.j2"] = "jinja",
		[".*%.htm%.j2"] = "jinja",
		[".*%.xml%.j2"] = "jinja",
		[".*%.yaml%.j2"] = "jinja",
		[".*%.yml%.j2"] = "jinja",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "jinja", "jinja2" },
	callback = function()
		vim.opt_local.commentstring = "{# %s #}"
	end,
})
