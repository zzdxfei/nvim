---------------------------------------------------------
-- Options
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
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
vim.opt.scrolloff = 3
vim.opt.confirm = true

vim.g.enable_custom_mappings = true

---------------------------------------------------------
-- Autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

---------------------------------------------------------
-- Keymaps
local map = vim.keymap.set
local opt = { remap = false }

if vim.g.enable_custom_mappings then
  map('t', '`', '<Esc>', opt)
  map('t', '<Esc>', '`', opt)
  map('t', '<C-\\><C-\\>', '<C-\\><C-n>', opt)

  map({ 'i', 'n', 'v', 'o' }, '`', '<Esc>', opt)
  map({ 'i', 'n', 'v', 'o' }, '<Esc>', '`', opt)
  map('c', '`', '<C-c>', opt)
  map('c', '<Esc>', '`', opt)
end

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
map('n', '<leader>w', '<cmd>write<CR>', { desc = 'Write file' })
map('n', '<leader>o', '<cmd>q<CR>', { desc = 'Quit file' })

map('n', '<Tab>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '<S-Tab>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<leader>e', '<cmd>bdelete<CR>', { desc = 'Close this buffer' })

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

map('n', '<C-e>', '2<C-e>', { desc = 'Scroll down 2 lines' })
map('n', '<C-y>', '2<C-y>', { desc = 'Scroll up 2 lines' })

map('n', '<Left>', '<cmd>vertical resize -2<CR>', { desc = 'Decrease window width' })
map('n', '<Right>', '<cmd>vertical resize +2<CR>', { desc = 'Increase window width' })
map('n', '<Up>', '<cmd>resize +2<CR>', { desc = 'Increase window height' })
map('n', '<Down>', '<cmd>resize -2<CR>', { desc = 'Decrease window height' })

-- DAP (Debug Adapter Protocol)
map('n', '<leader>b', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = 'Toggle breakpoint' })
map('n', '<F5>', "<cmd>lua require'dap'.continue()<CR>", { desc = 'Continue' })
map('n', '<F6>', "<cmd>lua require'dap'.run_to_cursor()<CR>", { desc = 'Run to cursor' })
map('n', '<F7>', "<cmd>lua require'dap'.step_over()<CR>", { desc = 'Step over' })
map('n', '<F8>', "<cmd>lua require'dap'.step_into()<CR>", { desc = 'Step into' })
map('n', '<F9>', "<cmd>lua require'dapui'.eval()<CR>", { desc = 'Evaluate expression' })

-- LSP
map('n', '<leader>d', '<cmd>lua vim.lsp.buf.implementation()<CR>', { desc = 'Goto implementation' })
map('n', '<leader>c', '<cmd>lua vim.lsp.buf.declaration()<CR>', { desc = 'Goto declaration' })

---------------------------------------------------------
-- Plugins
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' }, change = { text = '~' }, delete = { text = '_' },
        topdelete = { text = '‾' }, changedelete = { text = '~' },
      },
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ', Down = '<Down> ', Left = '<Left> ', Right = '<Right> ',
          C = '<C-…> ', M = '<M-…> ', D = '<D-…> ', S = '<S-…> ', CR = '<CR> ', Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ', BS = '<BS> ', Space = '<Space> ', Tab = '<Tab> ',
          F1 = '<F1>', F2 = '<F2>', F4 = '<F4>', F5 = '<F5>',
          F6 = '<F6>', F7 = '<F7>', F8 = '<F8>', F9 = '<F9>', F10 = '<F10>',
          F11 = '<F11>', F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>t', group = '[T]elescope' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require('telescope.builtin')
      map('n', '<leader>tt', builtin.builtin, { desc = '[T]elescope [S]elect' })
      map('n', '<leader>tf', builtin.find_files, { desc = '[T]elescope [F]ind files' })
      map('n', '<leader>tg', builtin.live_grep, { desc = '[T]elescope [G]rep' })
      map('n', '<leader>td', builtin.diagnostics, { desc = '[T]elescope [D]iagnostics' })
      map('n', '<leader>tr', builtin.registers, { desc = '[T]elescope [R]egisters' })
      map('n', '<leader>t.', builtin.oldfiles, { desc = '[T]elescope Recent files' })
      map('n', '<leader>tb', builtin.buffers, { desc = '[T]elescope [B]uffers' })
    end,
  },

  -- LSP Plugins
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'x' })
          map('grr', require('telescope.builtin').lsp_references, '[R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[I]mplementations')
          map('grd', require('telescope.builtin').lsp_definitions, '[D]efinitions')
          map('grD', vim.lsp.buf.declaration, '[D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Document symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[T]ype definition')

          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has('nvim-0.11') == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>h', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

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
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        jedi_language_server = {},
        clangd = {},
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- 'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
      },

      appearance = { nerd_font_variant = vim.g.have_nerd_font and 'normal' or 'mono' },

      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },

  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = true },
        },
      }
      vim.cmd.colorscheme('tokyonight-night')
    end,
  },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.pairs').setup({ mappings = { ['`'] = false } })
      require('mini.indentscope').setup()
      require('mini.tabline').setup()
      require('mini.sessions').setup({
        directory = vim.fn.stdpath('data') .. '/sessions',
        autoread = true,
        autowrite = true,
      })
      require('mini.ai').setup { n_lines = 500 }

      local statusline = require('mini.statusline')
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        view = { width = 30 },
        filters = { git_ignored = false },
      })
      vim.keymap.set('n', '<F2>', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
      vim.keymap.set('n', '<leader>f', '<cmd>NvimTreeFindFile<CR>', { desc = 'Find current file in tree' })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup({
        ensure_installed = {
          'bash', 'c', 'diff', 'html', 'lua', 'luadoc',
          'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc',
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = {
          enable = true,
          disable = { 'ruby' },
        },
      })
    end,
  },

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'mfussenegger/nvim-dap-python',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      local dapvt = require('nvim-dap-virtual-text')

      local function configure()
        local signs = {
          DapBreakpoint = { text = '🔴', texthl = 'DiagnosticSignError' },
          DapStopped = { text = '🔥', texthl = 'DiagnosticSignInfo', linehl = 'Visual' },
          DapBreakpointRejected = { text = '🐞', texthl = 'DiagnosticSignHint' },
        }
        for name, opts in pairs(signs) do
          vim.fn.sign_define(name, opts)
        end
      end

      local function configure_exts()
        dapvt.setup {
          commented = true,
          virt_text_pos = 'eol',
        }

        dapui.setup {}
        dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
        dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
        dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
      end

      local function configure_debuggers()
        local python_path = vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python3'
        require('dap-python').setup(python_path)

        pcall(require, 'dap-python-config')

        local cmd_path = vim.fn.stdpath('data') .. '/mason/bin/OpenDebugAD7'
        if vim.fn.has('win32') == 1 then cmd_path = cmd_path .. '.exe' end

        dap.adapters.cppdbg = {
          id = 'cppdbg',
          type = 'executable',
          command = cmd_path,
        }

        local cpp_config = {
          {
            name = 'Launch file',
            type = 'cppdbg',
            request = 'launch',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopAtEntry = true,
          },
          {
            name = 'Attach to gdbserver :1234',
            type = 'cppdbg',
            request = 'launch',
            MIMode = 'gdb',
            miDebuggerServerAddress = 'localhost:1234',
            miDebuggerPath = '/usr/bin/gdb',
            cwd = '${workspaceFolder}',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
          },
        }
        dap.configurations.cpp = cpp_config
        dap.configurations.c = cpp_config
      end

      configure()
      configure_exts()
      configure_debuggers()
    end,
  },

  {
    'folke/sidekick.nvim',
    opts = {
      cli = {
        mux = {
          backend = 'tmux',
          enabled = false,
        },
        tools = {
          qodercli = {
            cmd = { 'qodercli' },
            is_proc = '\\<qodercli\\>',
          },
          codex = {
            cmd = { 'codex' },
            is_proc = '\\<codex\\>',
          },
        },
      },
    },
    keys = {
      -- {
      --   '<Tab>',
      --   function()
      --     if not require('sidekick').nes_jump_or_apply() then
      --       return '<Tab>'
      --     end
      --   end,
      --   expr = true,
      --   desc = 'Goto/Apply Next Edit Suggestion',
      -- },
      {
        '<leader>aa',
        function() require('sidekick.cli').focus() end,
        desc = 'Sidekick Focus',
        mode = { 'n', 't', 'x' },
      },
      {
        '<leader>as',
        function() require('sidekick.cli').select() end,
        desc = 'Select CLI',
      },
      {
        '<leader>ad',
        function() require('sidekick.cli').close() end,
        desc = 'Detach a CLI Session',
      },
      {
        '<leader>at',
        function() require('sidekick.cli').send({ msg = '{this}' }) end,
        mode = { 'x', 'n' },
        desc = 'Send This',
      },
      {
        '<leader>af',
        function() require('sidekick.cli').send({ msg = '{file}' }) end,
        desc = 'Send File',
      },
      {
        '<leader>av',
        function() require('sidekick.cli').send({ msg = '{selection}' }) end,
        mode = { 'x' },
        desc = 'Send Visual Selection',
      },
      {
        '<leader>ap',
        function() require('sidekick.cli').prompt() end,
        mode = { 'n', 'x' },
        desc = 'Sidekick Select Prompt',
      },
      {
        '<leader>ac',
        function() require('sidekick.cli').toggle({ name = 'claude', focus = true }) end,
        desc = 'Sidekick Toggle Claude',
      },
      {
        '<leader>aq',
        function() require('sidekick.cli').toggle({ name = 'qodercli', focus = true }) end,
        desc = 'Sidekick Toggle QoderCLI',
      },
      {
        '<leader>ax',
        function() require('sidekick.cli').toggle({ name = 'codex', focus = true }) end,
        desc = 'Sidekick Toggle Codex',
      },
      {
        '<leader>ar',
        function()
          vim.ui.input({ prompt = 'Register: ' }, function(reg)
            if reg then
              local content = vim.fn.getreg(reg)
              require('sidekick.cli').send({ text = require('sidekick.text').to_text(content) })
            end
          end)
        end,
        desc = 'Send register content',
      },
    },
  },

  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup({
        size = 20,
        open_mapping = [[<F4>]],
        hide_numbers = true,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        direction = 'horizontal',
        close_on_exit = true,
        shell = 'fish',
      })
      map('n', '<leader>t%', function()
        local Terminal = require('toggleterm.terminal').Terminal
        Terminal:new({ direction = 'horizontal' }):open()
      end, { desc = 'Open horizontal terminal' })
      map('n', '<leader>t"', function()
        local Terminal = require('toggleterm.terminal').Terminal
        Terminal:new({ direction = 'vertical' }):open()
      end, { desc = 'Open vertical terminal' })
    end,
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙', keys = '🗝',
      plugin = '🔌', runtime = '💻', require = '🌙', source = '📄', start = '🚀',
      task = '📌', lazy = '💤 ',
    } or {},
  },
})

-- vim: ts=2 sts=2 sw=2 et
