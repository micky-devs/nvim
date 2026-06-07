-- LSP Configuration: Language Server Protocol support
--
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Mason: Package manager for LSP servers, formatters, linters
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- LSP status indicator
    { 'j-hui/fidget.nvim', opts = { notification = { window = { avoid = { 'NvimTree' } } } } },

    -- Completion capabilities (will be used when we add nvim-cmp)
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    vim.lsp.log.set_level('ERROR')

    -- This function gets run when an LSP attaches to a particular buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        -- Helper function for creating keymaps
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Essential LSP keymaps
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Highlight references under cursor
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- Toggle inlay hints if supported
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Configure diagnostics display
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
      },
    }

    -- LSP server capabilities (enhanced by nvim-cmp)
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Define LSP servers to install and configure
    local servers = {
      -- 0 Config 
      ts_ls = {},
      terraformls = {},
      emmet_language_server = {},
      html = {},
      tailwindcss = {},
      gopls = {},
      gh_actions_ls = {},
      -- Python
      pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = 'workspace',
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
            },
            defaultInterpreterPath = ".venv/bin/python",
          },
        },
      },

      -- Lua (for Neovim configuration)
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- Recognize the `vim` global
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              -- Make server aware of Neovim runtime files
              library = {
                [vim.fn.expand '$VIMRUNTIME/lua'] = true,
                [vim.fn.stdpath 'config' .. '/lua'] = true,
              },
            },
          },
        },
      },
    }

    -- Apply capabilities to every server, then register per-server config.
    vim.lsp.config('*', { capabilities = capabilities })
    for server_name, config in pairs(servers) do
      vim.lsp.config(server_name, config)
    end

    -- Ensure servers are installed
    require('mason-tool-installer').setup { ensure_installed = vim.tbl_keys(servers) }

    -- mason-lspconfig auto-enables installed servers using the configs above.
    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_enable = true,
    }
  end,
}

