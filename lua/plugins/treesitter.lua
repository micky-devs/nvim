return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local ts = require 'nvim-treesitter'

    local ensure_installed = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
      'javascript',
      'typescript',
      'terraform',
      'yaml',
      'ruby',
      'python',
    }

    ts.install(ensure_installed)

    -- Treesitter features are not enabled by options on the `main` branch; they
    -- must be turned on per buffer. Ruby is excluded from treesitter indent as
    -- its parser-based indentation is unreliable (matches old `master` config).
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-enable', { clear = true }),
      callback = function(args)
        local ft = args.match
        local lang = vim.treesitter.language.get_lang(ft)
        if not (lang and vim.treesitter.language.add(lang)) then
          return
        end

        vim.treesitter.start(args.buf, lang)

        if ft == 'ruby' then
          vim.bo[args.buf].syntax = 'on'
        else
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
