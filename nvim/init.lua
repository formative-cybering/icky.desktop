---@diagnostic disable: undefined-global

-- [[ Keymaps ]]
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

-- Colorscheme & Highlights
vim.cmd.colorscheme("oxocarbon")
vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi StatusLine guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE ctermbg=NONE
]])

-- Indentation & Tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Wrapping & Formatting
vim.opt.wrap = false
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

-- [[ Filetype Detection ]]
vim.filetype.add({
  filename = {
    [".tidal"] = "haskell",
  },
})

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

  use("nyoom-engineering/oxocarbon.nvim")

  use("andweeb/presence.nvim")
  use({
    "dcampos/nvim-snippy",
    config = function()
      require("snippy").setup({
        snippet_paths = { "~/.config/nvim/snippets" },
        mappings = {
          is = {
            ["<Tab>"] = "expand_or_advance",
            ["<S-Tab>"] = "previous",
          },
          nx = {
            ["<leader>x"] = "cut_text",
          },
        },
      })
    end,
  })
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
          haskell = { "ormolu" },
          javascript = { "deno_fmt" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
      })
    end,
  })

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require "nvim-treesitter.configs".setup {
        incremental_selection = {
          enable = true,
          keymaps = {
            node_incremental = "v",
            node_decremental = "V",
          },
        },
      }
    end,
  }

  use {
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
      }
    end
  }

  if packer_bootstrap then
    require("packer").sync()
  end
end)
