local utils = require('utils')

local indent = 2

-- can you splat these or something
local cmd = vim.cmd
local g = vim.g
local o = vim.o
local bo = vim.bo
local wo = vim.wo
local api = vim.api
local fn = vim.fn
local key = vim.api.nvim_set_keymap
local map = utils.map

-- install packer
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

api.nvim_exec(
  [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]],
  false
)

local use = require('packer').use
require('packer').startup(function()
  -- the package manager itself
  use 'wbthomason/packer.nvim'

  -------------------------------------------------- 
  -- standard plugins
  
  use 'tpope/vim-commentary' -- "gc" to comment visual regions/lines
  use 'tpope/vim-surround'
  use 'easymotion/vim-easymotion'

  -- git commands
  use 'tpope/vim-fugitive'
  -- github
  use 'tpope/vim-rhubarb'

  use 'nixprime/cpsm'
  use 'romgrk/fzy-lua-native'
  use 'ryanoasis/vim-devicons'
  use 'gelguy/wilder.nvim'

  -------------------------------------------------- 
  -- languages/lsp-related
  
  use 'tpope/vim-markdown'
  use 'stephpy/vim-yaml'
  use 'mzlogin/vim-markdown-toc'

  -- use 'ludovicchabant/vim-gutentags' -- Automatic tags management
  use 'nvim-lua/plenary.nvim'
  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } } }

  -------------------------------------------------- 
  -- appearance
  
  use 'joshdick/onedark.vim' -- Theme inspired by Atom
  use 'tamelion/neovim-molokai'
  use 'ayu-theme/ayu-vim'
  use 'shaunsingh/nord.nvim'
  use 'xiyaowong/nvim-transparent' -- transparent bg
  use 'itchyny/lightline.vim' -- Fancier statusline
  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  -- Add git related info in the signs columns and popups
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  -- use 'nvim-treesitter/nvim-treesitter'
  -- Additional textobjects for treesitter
  -- use 'nvim-treesitter/nvim-treesitter-textobjects'
  -- use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use { 'neoclide/coc.nvim', branch = 'release' }
  -- use 'hrsh7th/nvim-compe' -- Autocompletion plugin
  -- use 'L3MON4D3/LuaSnip' -- Snippets plugin
end)

-- highlight on yank
api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
  false
)

o.clipboard = 'unnamedplus'

o.expandtab = true
o.shiftwidth = indent

-- incremental live completion
o.inccommand = 'nosplit'
o.incsearch = true

-- set highlight on search
o.hlsearch = false
-- use line numbers, specifically relative ones
wo.number = true
wo.relativenumber = true

-- do not save when switching buffers
o.hidden = true
cmd [[set shortmess+=c]]
-- save undo history
o.undofile = true
bo.undofile = true
-- faster updates
o.updatetime = 100
-- more space for coc messages
o.cmdheight = 3

-- enable mouse mode
o.mouse = 'a'
-- enable break indent
o.breakindent = true

-- case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

wo.signcolumn = 'number'


-- Set completeopt to have a better completion experience
o.completeopt = 'menuone,noinsert'

--Set colorscheme (order is important here)
o.termguicolors = true
o.background = 'dark'
-- vim.g.onedark_terminal_italics = 2
-- vim.g.nord_contrast = false
-- vim.g.nord_disable_background = true
-- vim.g.nord_borders = true
-- require('nord').set()
cmd [[
  let ayucolor="mirage"
  colorscheme ayu
]]
require("transparent").setup({
  enable = true
})

-- lightline config
g.lightline = {
  colorscheme = 'ayu_mirage',
  active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'relativepath', 'modified' } } },
  component_function = { gitbranch = 'fugitive#head' },
}

-- indent_blankline config
g.indent_blankline_char = '┊'
g.indent_blankline_filetype_exclude = { 'help', 'packer' }
g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
g.indent_blankline_char_highlight = 'LineNr'
g.indent_blankline_show_trailing_blankline_indent = true
g.indent_blankline_show_current_context = true
g.indent_blankline_show_first_indent_level = false

--------------------------------------------------------------------------------
-- keybinds
--
-- coc config and some keybinds stolen from @sgalizia here:
-- https://neovim.discourse.group/t/the-300-line-init-lua-challenge/227/8
--------------------------------------------------------------------------------

-- use space as leader
key('', '<Space>', '<nop>', { noremap = true, silent = true })
g.mapleader = ' '
g.maplocalleader = ' '

-- swap ; and :
map('n', ';', ':')
map('n', ':', ';')
map('v', ';', ':')
map('v', ':', ';')

-- Y: yank until the end of line
key('n', 'Y', 'y$', { noremap = true })
-- gQ: ex mode, disable Q
key('', 'Q', '', {})
-- C-y: copy the whole file to clipboard
key('n', '<C-y>', [[<cmd>%y+<CR>]], { noremap = true, silent = true })

-- j/k: traverse visual lines
key('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
key('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- SPC hjkl: split navigation
map('n', '<leader>j', '<c-w>j')
map('n', '<leader>k', '<c-w>k')
map('n', '<leader>l', '<c-w>l')
map('n', '<leader>h', '<c-w>h')

-- SPC s s: save buffer
map('n', '<Leader>ss', ':w<cr>')

-- SPC s p: reload init.lua
map('n', '<Leader>hr', ':luafile ~/.config/nvim/init.lua<cr>', { silent = true })

--------------------------------------------------------------------------------
-- coc config
--------------------------------------------------------------------------------

-- make enter work to select coc suggestion
map('i', '<cr>', "pumvisible() ? '<c-y>' : '<c-g>u<cr>'", { expr = true })

-- allow tab to trigger auto-complete, refresh on backspace
map('i', '<tab>', 'v:lua.tab_complete()', { expr = true, silent = true })
map('i', '<s-tab>', 'v:lua.s_tab_complete()', { expr = true, silent = true })

-- code navigation
local map_coc_action_async = function(k, n)
  map('n', '<leader>' .. k, ":call CocActionAsync('" .. n .. "')<cr>", { silent = true })
end

map_coc_action_async('gd', 'jumpDefinition')
map_coc_action_async('gy', 'jumpTypeDefinition')
map_coc_action_async('gi', 'jumpImplementation')
map_coc_action_async('gr', 'jumpReferences')
map_coc_action_async('gR', 'jumpReferencesUsed')
map_coc_action_async('gp', 'diagnosticPrevious')
map_coc_action_async('gn', 'diagnosticNext')
map_coc_action_async('gP', 'diagnosticPrevious\'', '\'error')
map_coc_action_async('gN', 'diagnosticNext\'', '\'error')

-- map_coc('gI', 'diagnostic-info')
-- map_coc('krn', 'rename')
-- map_coc('kF', 'format')
-- map_coc('kf', 'format-selected')

map('n', '<leader>rn', '<Plug>(coc-rename)')
map('n', '<leader>qf', ':CocAction quickfix<cr>')

-- Use K to show documentation in the preview window
map('n', 'K', ':call ShowDocumentation()<cr>', { silent = true })
api.nvim_exec(
[[
function! ShowDocumentation()
  if (index(['vim','help'], &filetype) >=0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction
]]
, false)

-- Quick Fix

cmd [[
call wilder#enable_cmdline_enter()
set wildcharm=<Tab>
cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"
call wilder#set_option('modes', ['/', '?', ':'])

call wilder#set_option('pipeline', [ wilder#branch( wilder#python_file_finder_pipeline({ 'file_command': {_, arg -> stridx(arg, '.') != -1 ? ['fd', '-tf', '-H'] : ['fd', '-tf']}, 'dir_command': ['fd', '-td'], 'filters': ['cpsm_filter'], 'cache_timestamp': {-> 1}, }), wilder#cmdline_pipeline({ 'fuzzy': 1, 'fuzzy_filter': wilder#python_cpsm_filter(), 'set_pcre2_pattern': 0, }), wilder#python_search_pipeline({ 'pattern': wilder#python_fuzzy_pattern({ 'start_at_boundary': 0, }), }),), ])

let highlighters = [ wilder#pcre2_highlighter(), wilder#lua_fzy_highlighter(), ]

call wilder#set_option('renderer', wilder#renderer_mux({ ':': wilder#popupmenu_renderer({ 'highlighter': highlighters, 'left': [ ], 'right': [ ' ', wilder#popupmenu_scrollbar(), ], }), '/': wilder#wildmenu_renderer({ 'highlighter': highlighters, }), }))
]]

-- LSP settings

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { hl = 'GitGutterAdd', text = '+' },
    change = { hl = 'GitGutterChange', text = '~' },
    delete = { hl = 'GitGutterDelete', text = '_' },
    topdelete = { hl = 'GitGutterDelete', text = '‾' },
    changedelete = { hl = 'GitGutterChange', text = '~' },
  },
}

-- Telescope
require('telescope').setup {
  defaults = {
    layout_strategy = 'vertical',
    -- borderchars = { '┄','┆','┈','┊','┌','┐','┘','└',},
    -- borderchars = {'━','┃','━','┃','╆','╅','╃','╄',},
    -- borderchars = {'━','┃','━','┃','╆','╅','╃','╄',},
    borderchars = {'─','│','─','│','┌','┐','┘','└',},
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

local set_up_telescope = function()
  local set_keymap = function(mode, bind, cmd)
    key(mode, bind, cmd, { noremap = true, silent = true })
  end
  set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
  set_keymap('n', '<leader>tf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]])
  set_keymap('n', '<leader>tb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]])
  set_keymap('n', '<leader>th', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]])
  set_keymap('n', '<leader>td', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]])
  set_keymap('n', '<leader>tp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]])
  set_keymap('n', '<leader>tt', [[<cmd>lua require('telescope.builtin').tags()<CR>]])
  set_keymap('n', '<leader>tT', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]])
  set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]])
  -- set_keymap('n', '<leader>sf', [[<cmd>lua vim.lsp.buf.formatting()<CR>]])
end

set_up_telescope()

g.vim_markdown_auto_insert_bullets = 0

