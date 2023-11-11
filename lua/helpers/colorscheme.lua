-- -- Fetch and setup colorscheme if available, otherwise just return 'default'
-- -- This should prevent Neovim from complaining about missing colorschemes on first boot
-- local function get_if_available(name, opts)
-- 	local lua_ok, colorscheme = pcall(require, name)
-- 	if lua_ok then
-- 		colorscheme.setup(opts)
-- 		return name
-- 	end
--
-- 	local vim_ok, _ = pcall(vim.cmd.colorscheme, name)
-- 	if vim_ok then
-- 		return name
-- 	end
--
-- 	return "default"
-- end
--
-- -- Uncomment the colorscheme to use
-- local colorscheme = get_if_available("catppuccin-mocha")
-- -- local colorscheme = get_if_available('gruvbox')
-- -- local colorscheme = get_if_available('rose-pine')
-- -- local colorscheme = get_if_available('everforest')
-- -- local colorscheme = get_if_available('melange')
--
-- return colorscheme
--
require("catppuccin").setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
    dark = "mocha",
  },
  transparent_background = true, -- disables setting the background color.
  show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
  term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false, -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15, -- percentage of the shade to apply to the inactive window
  },
  no_italic = false, -- Force no italic
  no_bold = false, -- Force no bold
  no_underline = false, -- Force no underline
  styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" }, -- Change the style of comments
    conditionals = { "italic" },
    loops = {"italic"},
    functions = {"italic"},
    keywords = {"bold"},
    strings = {},
    variables = {},
    numbers = {"italic"},
    booleans = {"italic"},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {},
  custom_highlights = function(colors)
    return {
      Comment = { fg = "#89AEB1"},
      LineNr = { fg = colors.overlay0 }
    }
  end,
  integrations = {
    cmp = true,
    gitsigns = false,
    nvimtree = false,
    treesitter = true,
    notify = false,
    mini = false,
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
