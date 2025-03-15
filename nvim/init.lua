vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
vim.keymap.set(
	{ "x", "n", "s" },
	"<C-e>",
	"<esc>mz<bar>vip<bar>:w !sh /home/slash/.config/tidal/s_tidal.sh<CR>`z",
	{ desc = "Tidal wave", silent = true, noremap = true }
)
vim.keymap.set(
	{ "i" },
	"<C-e>",
	"<esc>mz<bar>vip<bar>:w !sh /home/slash/.config/tidal/s_tidal.sh<CR>`zli",
	{ desc = "Tidal wave", silent = true, noremap = true }
)
-- vim.keymap.set({ "x", "n", "s" }, "<C-r>", ":Files<CR>", { desc = "Open files" })
vim.keymap.set(
	{ "i", "x", "n", "s" },
	"<C-t>",
	'<esc>mz<bar>f"<bar>va"<bar>:w !sh ~/.config/tidal/tactus.sh<CR>',
	{ desc = "Tidal Info" }
)

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.hidden = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.background = "dark"
vim.cmd.colorscheme("oxocarbon")

vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi StatusLine guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE ctermbg=NONE
]])

require("smear_cursor").enabled = true

--BUFFER MANAGER
local opts = { noremap = true }
local map = vim.keymap.set
--Setup
require("buffer_manager").setup({
	select_menu_item_commands = {
		v = {
			key = "<M-v>",
			command = "vsplit",
		},
		h = {
			key = "<M-h>",
			command = "split",
		},
	},
	focus_alternate_buffer = false,
	short_file_names = true,
	short_term_names = true,
	loop_nav = false,
	highlight = "Normal:BufferManagerBorder",
	win_extra_options = {
		winhighlight = "Normal:BufferManagerNormal",
	},
})
--Navigate buffers bypassing the menu
local bmui = require("buffer_manager.ui")
local keys = "1234567890"
for i = 1, #keys do
	local key = keys:sub(i, i)
	map("n", string.format("<leader>%s", key), function()
		bmui.nav_file(i)
	end, opts)
end
-- Just the menu
map({ "t", "n" }, "<M-Space>", bmui.toggle_quick_menu, opts)
-- Open menu and search
map({ "t", "n" }, "<M-m>", function()
	bmui.toggle_quick_menu()
	-- wait for the menu to open
	vim.defer_fn(function()
		vim.fn.feedkeys("/")
	end, 50)
end, opts)
-- Next/Prev
map("n", "<M-j>", bmui.nav_next, opts)
map("n", "<M-k>", bmui.nav_prev, opts)

--

vim.opt.guicursor =
	"n-v-c-sm-i-ci-ve:block,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,i-ci-ve:ver25"

vim.filetype.add({
	filename = {
		[".tidal"] = "haskell",
	},
})

require("lspconfig").denols.setup({})

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	-- My plugins here
	use("nyoom-engineering/oxocarbon.nvim")
	use("tpope/vim-fugitive")
	use("tpope/vim-commentary")
	use("andweeb/presence.nvim")
	use("sphamba/smear-cursor.nvim")
	use({
		"junegunn/fzf.vim",
		requires = { "junegunn/fzf", run = ":call fzf#install()" },
	})
	use("nvim-lua/plenary.nvim")
	use("j-morano/buffer_manager.nvim")
	use({
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofmt" },
					haskell = { "ormolu" },
					javascript = { "deno_fmt" },
				},
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	})
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
