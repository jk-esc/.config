vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt -- making it easier

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation 
opt.autoindent = true 
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- line wrap
opt.wrap = false 

-- search settings 
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = false 

-- set the CursorLine background to light gray

-- appearance 
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace 
opt.backspace = "indent,eol,start"

-- clipboard 
opt.clipboard:append("unnamedplus")

-- split windows 
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")

-- turn off swapfiles
opt.swapfile = false


