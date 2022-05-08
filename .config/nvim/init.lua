pcall(require,"impatient")

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  print("Installing packer...")
  vim.fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]]

-- local use = require('packer').use
require('packer').startup{
  function(use)
    use 'wbthomason/packer.nvim' -- Package manager
    use 'lewis6991/impatient.nvim'
    use 'kyazdani42/nvim-web-devicons' -- Pretty symbols
    -- UI to select things (files, grep results, open buffers...)
    use { 'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        'telescope-fzf-native.nvim',
      },
    }
   use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
      config = function()
        require("telescope").load_extension("fzf")
      end,
    }
    use 'nlknguyen/papercolor-theme' -- Theme 
    use 'itchyny/lightline.vim' -- Fancier statusline
    -- Add indentation guides even on blank lines
    use 'lukas-reineke/indent-blankline.nvim'
    -- Add git related info in the signs columns and popups
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip' -- Snippets plugin
    use 'windwp/nvim-autopairs'
    use 'fatih/vim-go'
  end,
  config = {
    -- Move to lua dir so impatient.nvim can cache it
    compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
  }
}

-- Tame tab settings; thanks https://arisweedler.medium.com/tab-settings-in-vim-1ea0863c5990
vim.o.tabstop=4
vim.o.shiftwidth=4
vim.o.softtabstop=4
vim.o.expandtab=true
vim.o.smartindent=true

-- Show hidden characters, tabs, trailing whitespace
vim.o.list=true
vim.o.listchars="tab:→ ,trail:·,nbsp:·"

-- Highlight current line
vim.o.cursorline=true

--Set highlight on search
vim.o.hlsearch = true

--Make line numbers default
vim.wo.number = true

--Enable break indent
vim.o.breakindent = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Split below and to the right
vim.o.splitbelow=true
vim.o.splitright=true

-- Disable modelines as a security precaution
vim.o.modelines=0
vim.o.modeline=false

-- Automatically :write before running command
vim.o.autowrite=true

-- No backups or swap
vim.o.backup=false
vim.o.writebackup=false
vim.o.swapfile=false

-- Centralize undo history
vim.o.undofile=true
vim.o.undodir= vim.env.HOME .. '/.vim/undos'

--Set colorscheme (order is important here)
vim.o.colorcolumn='80,100'
vim.o.termguicolors = true
vim.o.background = 'dark'
vim.cmd [[colorscheme PaperColor]]
vim.cmd [[highlight ColorColumn ctermbg=238 guibg=#232728]]

--Set statusbar
vim.g.lightline = {
  colorscheme = 'one',
  active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } },
}

--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

--Map blankline
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_show_trailing_blankline_indent = false

require('nvim-web-devicons').setup {}

-- Autopairs
require('nvim-autopairs').setup{}

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
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  pickers = {
    buffers = {
        sort_lastused = true
    }
  },
  extensions = {
   fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  }
}

--Add leader shortcuts
vim.api.nvim_set_keymap('n', '<leader>lb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fa', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })

-- Window movement with Ctrl+(hjkl)
vim.api.nvim_set_keymap('n', '<C-j>', [[<C-w>j]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', [[<C-w>h]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-s>', [[<C-w>h]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', [[<C-w>k]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', [[<C-w>l]], { noremap = true, silent = true })
-- <C-,> won't work due to https://vimhelp.org/vim_faq.txt.html#faq-20.5
vim.api.nvim_set_keymap('t', '<C-j>', [[<C-\><C-N><C-w>j]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-h>', [[<C-\><C-N><C-w>h]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-s>', [[<C-\><C-N><C-w>h]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-k>', [[<C-\><C-N><C-w>k]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-l>', [[<C-\><C-N><C-w>l]], { noremap = true, silent = true })


-- Custom movement keys (s for left and , for down) in addition to hj
vim.api.nvim_set_keymap('', ',', 'j', { noremap = true })
vim.api.nvim_set_keymap('', 's', 'h', { noremap = true })
-- TEMPORARY: remove h and j bindings for practice
vim.api.nvim_set_keymap('', 'j', '', { noremap = true })
vim.api.nvim_set_keymap('', 'h', '', { noremap = true })

-- Explore with -
vim.api.nvim_set_keymap('n', '-', [[:Explore<CR>]], { noremap = true, silent = true })

if vim.fn.has('unix') then
    vim.api.nvim_set_keymap('v', '<leader>cc', '"+y', {})
elseif vim.fn.has('macunix') then
    vim.api.nvim_set_keymap('v', '<leader>cc', '"*y', {})
end




-- LSP settings
local lspconfig = require 'lspconfig'
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable the following language servers
local servers = { 'gopls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Example custom server
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

lspconfig.sumneko_lua.setup {
  cmd = { '/usr/local/bin/lua-language-server' },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
 },
}


-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
 mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
  },
}



-- Netrw

-- Set treeview as default
vim.g.netrw_liststyle = 3


-- Language configurations


-- Go

-- Run `goimports` on your current file on every save
-- Might be be slow on large codebases, if so, just comment it out
vim.g.go_fmt_command = "goimports"

-- Status line types/signatures.
vim.g.go_auto_type_info = 1

vim.g.go_def_mode='gopls'
vim.g.go_info_mode='gopls'

--If you want to disable gofmt on save
--vim.g.go_fmt_autosave = 0



-- TF

vim.g.terraform_align=1
vim.g.terraform_fmt_on_save=1
