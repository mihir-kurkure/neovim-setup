local opts = {
  shiftwidth = 4,
  tabstop = 4,
  expandtab = true,
  wrap = false,
  termguicolors = true,
  number = true,
  relativenumber = false,
}

-- Set options from table
for opt, val in pairs(opts) do
  vim.o[opt] = val
end

-- Set other options
local colorscheme = require("helpers.colorscheme")
-- vim.cmd.colorscheme(colorscheme)

-- Transparent
vim.cmd("highlight Normal guibg=none")
vim.cmd("highlight NonText guibg=none")
vim.cmd("highlight Normal ctermbg=none")
vim.cmd("highlight NonText ctermbg=none")
vim.cmd("highlight NvimTreeNormal guibg=none")
vim.cmd("highlight NvimTreeNormal ctermbg=none")

--indent
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
--vim.opt.listchars:append "eol:↴"
vim.opt.clipboard = "unnamedplus"
