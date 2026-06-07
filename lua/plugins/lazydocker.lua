return {
  'crnvl96/lazydocker.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    window = {
      settings = {
        width = 0.9,
        height = 0.9,
        border = 'rounded',
        relative = 'editor',
      },
    },
  },
  keys = {
    {
      '<leader>ld',
      function()
        require('lazydocker').toggle({ engine = 'docker' })
      end,
      desc = 'Open lazy docker',
    },
  },
}
