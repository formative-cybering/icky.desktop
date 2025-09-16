---@diagnostic disable: undefined-global

-- [[ Keymaps ]]
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
vim.keymap.set(
	{ "x", "n", "s" },
	"<C-e>",
	"<esc>mz<bar>vip<bar>:w !sh /home/slash/.config/tidal/send_tidal.sh<CR>`z",
	{ desc = "Tidal wave", silent = true, noremap = true }
)
vim.keymap.set(
	{ "i" },
	"<C-e>",
	"<esc>mz<bar>vip<bar>:w !sh /home/slash/.config/tidal/send_tidal.sh<CR>`zli",
	{ desc = "Tidal wave", silent = true, noremap = true }
)
vim.keymap.set(
	{ "i", "x", "n", "s" },
	"<C-t>",
	'<esc>mz<bar>f"<bar>va"<bar>:w !sh ~/.config/tidal/tactus.sh<CR>',
	{ desc = "Tidal Info" }
)
-- Move lines up/down in normal and visual modes
vim.keymap.set("n", "K", ":m .-2<CR>", { noremap = true })
vim.keymap.set("n", "J", ":m .+1<CR>", { noremap = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv", { noremap = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv", { noremap = true })

-- [[ General Options ]]

-- UI Settings
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.guicursor =
	"n-v-c-sm-i-ci-ve:block,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,i-ci-ve:ver25"

-- Enable syntax and filetype
vim.opt.syntax = "on"

-- Haskell-vim settings
-- vim.g.haskell_classic_highlighting = 1
-- vim.g.haskell_indent_if = 3
-- vim.g.haskell_indent_case = 2
-- vim.g.haskell_indent_let = 4
-- vim.g.haskell_indent_where = 6

-- Colorscheme & Highlights
vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi StatusLine guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE ctermbg=NONE
  hi StatusLine guibg=NONE ctermbg=NONE
]])

-- Indentation & Tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Wrapping & Formatting
vim.opt.wrap = true
vim.opt.nrformats:remove("octal")

-- File Handling
vim.opt.hidden = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Clipboard & Filename
vim.opt.clipboard = "unnamedplus"
vim.opt.isfname:append("@-@")

-- Performance
vim.opt.updatetime = 50

-- [[ Packer Bootstrap ]]
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

-- [[ Plugins ]]
return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "haskell", "supercollider", "hyprlang" },
				highlight = { enable = true },
			})
		end,
	})

	use({
		"thgrund/tidal.nvim",
		config = function()
			require("tidal").setup({
				boot = {
					tidal = {
						--- Command to launch ghci with tidal installation
						cmd = "ghci",
						args = {
							"-v0",
						},
						--- Tidal boot file path
						file = "/home/slash/.config/tidal/bootTidal.hs",
						enabled = true,
						highlight = {
							osc = {
								ip = "127.0.0.1",
								port = 6013,
							},
							fps = 30,
						},
						highlightStyle = {
							osc = {
								ip = "127.0.0.1",
								port = 3335,
							},
						},
					},
					sclang = {
						--- Command to launch SuperCollider
						cmd = "sclang",
						args = {},
						--- SuperCollider boot file
						file = vim.api.nvim_get_runtime_file("/home/slash/.config/SuperCollider/startup.scd", false)[1],
						enabled = false,
					},
					split = "v",
				},
				--- Default keymaps
				--- Set to false to disable all default mappings
				--- @type table | nil
				mappings = {
					send_line = { mode = { "i", "n" }, key = "<leader>CR>" },
					send_visual = { mode = { "x" }, key = "<S-CR>" },
					send_block = { mode = { "i", "n", "x" }, key = "<S-CR>" },
					send_node = { mode = "n", key = "<leader><n>" },
					send_silence = { mode = "n", key = "<leader>d" },
					send_hush = { mode = "n", key = "<leader><Esc>" },
				},
				---- Configure highlight applied to selections sent to tidal interpreter
				selection_highlight = {
					--- Highlight definition table
					--- see ':h nvim_set_hl' for details
					--- @type vim.api.keyset.highlight
					highlight = { link = "IncSearch" },
					--- Duration to apply the highlight for
					timeout = 150,
				},
			})
		end,
		-- Configure treesitter to ensure parsers
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "haskell", "supercollider" },
			highlight = { enable = true },
		}),
	})

	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup()
		end,
	})

	use("tpope/vim-repeat")

	use({
		"thgrund/tidal-makros.nvim",
		config = function()
			require("makros").setup()
		end,
	})

	use({
		"slugbyte/lackluster.nvim",
		config = function()
			require("lackluster").setup({
				tweak_background = { normal = "none" },
			})
			vim.cmd([[colorscheme lackluster]])
			vim.cmd([[hi StatusLine guibg=NONE ctermbg=NONE]])
		end,
	})
	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					globalstatus = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
			-- Force transparent background for lualine
			vim.cmd([[
      hi lualine_a_normal guibg=NONE ctermbg=NONE
      hi lualine_b_normal guibg=NONE ctermbg=NONE
      hi lualine_c_normal guibg=NONE ctermbg=NONE
      hi lualine_x_normal guibg=NONE ctermbg=NONE
      hi lualine_y_normal guibg=NONE ctermbg=NONE
      hi lualine_z_normal guibg=NONE ctermbg=NONE
      hi lualine_a_command guibg=NONE ctermbg=NONE
      hi lualine_b_command guibg=NONE ctermbg=NONE
      hi lualine_c_command guibg=NONE ctermbg=NONE
      hi lualine_x_command guibg=NONE ctermbg=NONE
      hi lualine_y_command guibg=NONE ctermbg=NONE
      hi lualine_z_command guibg=NONE ctermbg=NONE
      hi lualine_a_insert guibg=NONE ctermbg=NONE
      hi lualine_b_insert guibg=NONE ctermbg=NONE
      hi lualine_c_insert guibg=NONE ctermbg=NONE
      hi lualine_x_insert guibg=NONE ctermbg=NONE
      hi lualine_y_insert guibg=NONE ctermbg=NONE
      hi lualine_z_insert guibg=NONE ctermbg=NONE
    ]])
		end,
	})

	-- use("neovimhaskell/haskell-vim")

	use("andweeb/presence.nvim")

	-- use({
	-- 	"dcampos/nvim-snippy",
	-- 	config = function()
	-- 		require("snippy").setup({
	-- 			snippet_paths = { "~/.config/nvim/snippets" },
	-- 			mappings = {
	-- 				is = {
	-- 					["<Tab>"] = "expand_or_advance",
	-- 					["<S-Tab>"] = "previous",
	-- 				},
	-- 				nx = {
	-- 					["<leader>x"] = "cut_text",
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- })

	use("mbbill/undotree")

	-- use("nvim-lua/plenary.nvim")

	use({
		"sphamba/smear-cursor.nvim",
		config = function()
			require("smear_cursor").enabled = true
		end,
	})

	use("tpope/vim-commentary")

	use("tpope/vim-fugitive")

	use({
		"junegunn/fzf.vim",
		requires = { "junegunn/fzf", run = ":call fzf#install()" },
		config = function()
			vim.api.nvim_create_user_command("FF", "Files", {})
			vim.api.nvim_create_user_command("FB", "Buffers", {})
			vim.api.nvim_create_user_command("FL", "Lines", {})
			vim.api.nvim_create_user_command("FR", "Rg", {})
		end,
	})

	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("lspconfig").denols.setup({})
		end,
	})

	use({
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofmt" },
					haskell = { "fourmolu" },
					javascript = { "deno_fmt" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	})

	use({
		"daliusd/incr.nvim",
		config = function()
			require("incr").setup({
				incr_key = "<Tab>", -- Increment selection
				decr_key = "<S-Tab>", -- Decrement selection
			})
		end,
	})

	use({
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
			})
		end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
