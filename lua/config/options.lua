vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.showtabline = 2

-- Setup numbered tabline with error handling
vim.opt.tabline = '%!v:lua.require("tabline").safe_tabline()'

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Ensure .tf files are detected as terraform
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.tf',
  callback = function()
    vim.bo.filetype = 'terraform'
  end,
})

-- Treat .env.* like .env (same syntax highlighting)
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '.env.*',
  callback = function()
    vim.bo.filetype = 'sh'
  end,
})
