return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	cmd = "Dashboard",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- dashboard-nvim writes its project cache asynchronously on VimLeavePre: if nvim
	-- exits before libuv flushes the buffer, the file is left truncated and
	-- loadstring() fails on the next start. Repair it, keeping the intact paths.
	init = function()
		local path = vim.fn.stdpath("cache") .. "/dashboard/cache"
		local fd = io.open(path, "r")
		if not fd then
			return
		end
		local data = (fd:read("*a") or ""):gsub("%z", "")
		fd:close()
		if loadstring(data) then
			return
		end

		local projects = {}
		for dir in data:gmatch('"([^"]*)"') do
			table.insert(projects, dir)
		end
		local out = io.open(path, "w")
		if not out then
			return
		end
		out:write("return " .. vim.inspect(projects))
		out:close()
		vim.notify("dashboard: project cache was truncated, rebuilt it", vim.log.levels.WARN)
	end,
	keys = {
		{ "<leader>od", "<cmd>Dashboard<cr>", desc = "Open dashboard" },
	},
	opts = function()
		local function find_files(cwd)
			local opts = { hidden = true }
			if cwd and cwd ~= "" then
				opts.cwd = cwd
			end
			require("telescope.builtin").find_files(opts)
		end

		local function live_grep(cwd)
			local opts = {}
			if cwd and cwd ~= "" then
				opts.cwd = cwd
			end
			require("telescope.builtin").live_grep(opts)
		end

		local logo = [[
  🌲   🌳
]]

		return {
			theme = "hyper",
			hide = {
				statusline = false,
			},
			config = {
				header = vim.split(string.rep("\n", 4) .. logo .. "\n", "\n"),
				shortcut = {
					{ icon = " ", desc = "Files", key = "f", action = find_files },
					{ icon = " ", desc = "Grep", key = "g", action = live_grep },
					{ icon = " ", desc = "Recent", key = "r", action = "Telescope oldfiles" },
					{
						icon = " ",
						desc = "Config",
						key = "c",
						action = function()
							require("telescope.builtin").find_files({
								cwd = vim.fn.stdpath("config"),
								hidden = true,
							})
						end,
					},
					{ icon = " ", desc = "New", key = "n", action = "enew | startinsert" },
					{ icon = "󰒲 ", desc = "Lazy", key = "l", action = "Lazy" },
					{
						icon = " ",
						desc = "Quit",
						key = "q",
						action = function()
							vim.api.nvim_input("<cmd>qa<cr>")
						end,
					},
				},
				project = {
					enable = true,
					limit = 8,
					icon = " ",
					label = "Recent directories",
					action = function(path)
						vim.cmd("cd " .. vim.fn.fnameescape(path))
						require("telescope.builtin").find_files({
							cwd = path,
							hidden = true,
						})
					end,
				},
				mru = {
					enable = true,
					limit = 8,
					icon = " ",
					label = "Recent files",
					cwd_only = false,
				},
				packages = { enable = true },
				footer = function()
					local stats = require("lazy").stats()
					local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
					return {
						"Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
					}
				end,
			},
		}
	end,
}
