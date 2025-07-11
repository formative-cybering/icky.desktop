---@diagnostic disable: undefined-global

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

vim.opt.clipboard = "unnamedplus"
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

vim.opt.nrformats:remove("octal")

vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi StatusLine guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE ctermbg=NONE
]])

require("smear_cursor").enabled = true

vim.opt.guicursor =
"n-v-c-sm-i-ci-ve:block,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,i-ci-ve:ver25"

vim.filetype.add({
  filename = {
    [".tidal"] = "haskell",
  },
})

require("lspconfig").denols.setup({})

require("snippy").setup({
  snippet_paths = { "~/.config/nvim/snippets" },
  mappings = {
    is = {                             -- Insert and select mode mappings
      ["<Tab>"] = "expand_or_advance", -- Expand snippet or jump to next placeholder
      ["<S-Tab>"] = "previous",        -- Jump to previous placeholder
    },
    nx = {                             -- Normal and visual mode mappings
      ["<leader>x"] = "cut_text",      -- Cut selected text for snippet creation
    },
  },
})

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
  use("mbbill/undotree")
  use("tpope/vim-fugitive")
  use("tpope/vim-commentary")
  use("andweeb/presence.nvim")
  use("sphamba/smear-cursor.nvim")
  use("dcampos/nvim-snippy")
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ':TSUpdate'
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
  use({
    "junegunn/fzf.vim",
    requires = { "junegunn/fzf", run = ":call fzf#install()" },
  })
  use("nvim-lua/plenary.nvim")
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
