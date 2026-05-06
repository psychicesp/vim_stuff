vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- General editor behavior
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.termguicolors = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.updatetime = 250
opt.timeoutlen = 400

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Indentation defaults
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Persistent undo
opt.undofile = true

-- System clipboard when a clipboard provider exists.
-- On headless servers, :checkhealth may suggest installing xclip/wl-clipboard.
opt.clipboard = "unnamedplus"

vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")