vim.g.mapleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- exit insert mode quickly
map("i", "jj", "<Esc>", opts)

-- move code lines
map('v', 'K', ":m '<-2<CR>gv=gv")
map('v', 'J', ":m '>+1<CR>gv=gv")

-- navigation
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

-- ### SPLIT MANAGEMENT ###
-- ## SPLITS ##
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
map("n", "<leader>sd", "<cmd>tabnew %<CR>", { desc = "Duplicate current tab" }) --  move current buffer to new tab

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- Resize splits using arrow keys + Control
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- ## TABS ##
map("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
-- map("n", "<leader>td", "<cmd>tabnew %<CR>", { desc = "Duplicate current tab" }) --  move current buffer to new tab

-- Navigate between tabs using Tab and Shift+Tab
map("n", "<Tab>", "<cmd>tabnext<CR>", { desc = "Go to next tab" })
map("n", "<S-Tab>", "<cmd>tabprevious<CR>", { desc = "Go to previous tab" })

-- DIFF SPLIT VERTICAL
map("n", "<leader>dv", function()
	local cur_win = vim.api.nvim_get_current_win()
	local wins = vim.api.nvim_tabpage_list_wins(0)

	-- Sort windows left-to-right by their column position
	table.sort(wins, function(a, b)
		local a_pos = vim.api.nvim_win_get_position(a)[2]
		local b_pos = vim.api.nvim_win_get_position(b)[2]
		return a_pos < b_pos
	end)

	if #wins < 2 then
		print("Need at least 2 vertical splits.")
		return
	end

	-- Only apply to the two left-most windows
	vim.api.nvim_set_current_win(wins[1])
	vim.cmd("diffthis")
	vim.api.nvim_set_current_win(wins[2])
	vim.cmd("diffthis")

	-- Restore the original window focus
	vim.api.nvim_set_current_win(cur_win)
end, { desc = "Diff left and right vertical splits", noremap = true, silent = true })

map("n", "<leader>do", function()
	local cur_win = vim.api.nvim_get_current_win()
	local wins = vim.api.nvim_tabpage_list_wins(0)

	for _, win in ipairs(wins) do
		vim.api.nvim_set_current_win(win)
		vim.cmd("diffoff")
	end

	vim.api.nvim_set_current_win(cur_win)
end, { desc = "Turn off diff in all splits", noremap = true, silent = true })

-- Common
map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

-- paste without losing clipboard
map("x", "<leader>p", '"_dP', opts)

-- copy to system clipboard
map({ "n", "v" }, "<leader>y", '"+y', opts)

-- disable recording macros with Q
map("n", "Q", "<nop>", opts)

-- Buffer --
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })
-- map("n", "<tab>", function()
--   require("nvchad.tabufline").next()
-- end, { desc = "buffer goto next" })

-- map("n", "<S-tab>", function()
--   require("nvchad.tabufline").prev()
-- end, { desc = "buffer goto prev" })

-- map("n", "<leader>x", function()
--   require("nvchad.tabufline").close_buffer()
-- end, { desc = "buffer close" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- CODE --
-- -- formate code with "fm"
-- map({ "n", "x" }, "<leader>fm", function()
-- 	require("conform").format { lsp_fallback = true }
--   end, { desc = "general format file" })

-- map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- -- nvimtree
-- map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
-- map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- -- telescope
-- map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
-- map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
-- map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
-- map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
-- map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
-- map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
-- map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
-- map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
-- map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

-- map("n", "<leader>th", function()
--   require("nvchad.themes").open()
-- end, { desc = "telescope nvchad themes" })

-- map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
-- map(
--   "n",
--   "<leader>fa",
--   "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
--   { desc = "telescope find all files" }
-- )

-- split window shortcuts
map("n", "<leader>sv", ":vsplit<CR>", opts)
map("n", "<leader>sh", ":split<CR>", opts)

-- close current buffer
map("n", "<leader>x", ":bd<CR>", opts)

-- navigate buffers
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- resize windows with arrows
map("n", "<S-Up>", ":resize +2<CR>", opts)
map("n", "<S-Down>", ":resize -2<CR>", opts)
map("n", "<S-Left>", ":vertical resize -2<CR>", opts)
map("n", "<S-Right>", ":vertical resize +2<CR>", opts)

-- toggle numbers
map("n", "<leader>rn", function()
  vim.o.relativenumber = not vim.o.relativenumber
end, opts)

-- clear search highlight
map("n", "<ESC>", "<cmd>nohl<CR>", { desc = "Clear search highlights" })


-- Paste without overwrite
-- map("v", "p", "P", opts)

-- Undo quicker
map("n", "U", "<cmd>redo<CR>", opts)

-- ### QUICKFIX
-- next item
map("n", "<leader>jj", "<cmd>cnext<CR>", { desc = "Quickfix Next" })
map("n", "<leader>cn", "<cmd>cnext<CR>", { desc = "Quickfix Next" })
-- prev item
map("n", "<leader>kk", "<cmd>cprev<CR>", { desc = "Quickfix Prev" })
map("n", "<leader>cp", "<cmd>cprev<CR>", { desc = "Quickfix Prev" })
-- first item
map("n", "<leader>cf", "<cmd>cfirst<CR>", { desc = "Quickfix Last" })
-- last item
map("n", "<leader>cl", "<cmd>clast<CR>", { desc = "Quickfix Do" })
-- cdo
map("n", "<leader>cd", ":cdo ", { desc = "Quickfix Prev" })
-- open & close
map("n", "<leader>co", "<cmd>copen<CR>", { desc = "Quickfix Open" })
map("n", "<leader>cc", "<cmd>cclose<CR>", { desc = "Quickfix Close" })

-- ## REPLACE SELECTION ##
map(
	"v",
	"<C-r>",
	'"hy:%s/<C-r>h//gc<left><left><left>',
	{ noremap = true, silent = true, desc = "substitute selection" }
)
map(
	"v",
	"<leader>s",
	'"hy:%s/<C-r>h//gc<left><left><left>',
	{ noremap = true, silent = true, desc = "substitute selection" }
)

-- Yank path of current file
map(
	"n",
	"<leader>yp",
	[[:let @+ = expand('%:p')<CR>]],
	{ noremap = true, silent = true, desc = "Yank path of the current file" }
)

-- Yank current file name
map(
	"n",
	"<leader>yn",
	[[:let @+ = expand('%')<CR>]],
	{ noremap = true, silent = true, desc = "Yank current file name" }
)


-- Run macro bound to q with Q
map("n", "Q", "@q", opts)


-- RUN PYTHON ON THE RIGHT
function OpenTmuxPaneAndRunPython()
	local file = vim.fn.expand("%:p") -- Get full path of current file
	-- Create a new tmux split below
	vim.fn.system("tmux split-window -h")
	-- Send the commands to the new pane and keep it open
	vim.fn.system("tmux send-keys 'source ~/.venvs/py312/bin/activate && python " .. file .. " ; exec $SHELL' Enter")
	-- Switch focus to the newly created pane
	vim.fn.system("tmux select-pane -D")
end

map(
	"n",
	"<leader>py",
	[[<cmd>lua OpenTmuxPaneAndRunPython()<CR>]],
	{ noremap = true, silent = true, desc = "Open tmux vertical split & run Python (py312)" }
)


-- OPEN URL
function _G.open_url()
	-- Get the URL under cursor
	local url = vim.fn.expand("<cfile>")
	-- Check if URL has a protocol, add https if missing
	if not string.match(url, "^https?://") then
		url = "https://" .. url
	end
	-- Command to open URL (adjust path based on your OS)
	local cmd = ""
	if vim.fn.has("unix") == 1 then
		cmd = 'open "' .. url .. '"'
	elseif vim.fn.has("mac") == 1 then
		cmd = 'open "' .. url .. '"'
	end
	-- Execute the command
	vim.fn.system(cmd)
	-- print("Opening " .. url .. " in ")
end

-- Map the shortcut to <leader>op
vim.api.nvim_set_keymap("n", "<leader>op", ":lua open_url()<CR>", { noremap = true, silent = true })


-- INSERT IGNORE FOR PYRIGHT AT EOL
map("n", "<leader>li", function()
	local line = vim.fn.getline(".")
	vim.fn.setline(vim.fn.line("."), line .. "    # pyright: ignore")
end, { noremap = true, silent = true, desc = "Append '# pyright: ignore' at the end of the line" })


-- SEARCH SELECTION IN SCHOLAR
map(
	"n",
	"<leader>os",
	[[:<C-u>lua local query = vim.fn.getreg('"'):gsub(" ", "%%20"); vim.fn.system("xdg-open 'https://scholar.google.com/scholar?hl=en&as_sdt=0%2C5&q=" .. query .. "&btnG='")<CR>]],
	{ noremap = true, silent = true, desc = "Open Scholar yanked text" }
)
