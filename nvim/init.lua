local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local config_source = debug.getinfo(1, "S").source:sub(2)
local config_path = (vim.uv or vim.loop).fs_realpath(config_source) or config_source
local config_dir = vim.fn.fnamemodify(config_path, ":h")
local lazy_lockfile = config_dir .. "/lazy-lock.json"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local treesitter_parsers = {
  "regex",
  "vue",
  "pug",
  "scss",
  "css",
  "html",
  "javascript",
  "typescript",
  "lua",
  "vim",
  "vimdoc",
  "toml",
  "go",
  "python",
  "c",
  "cpp",
  "c_sharp",
}

require("lazy").setup({
  lockfile = lazy_lockfile,
  checker = {
    enabled = true,
    frequency = 86400,
  },
  spec = {
    {
      "tanvirtin/monokai.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        local monokai = require("monokai")
        local palette = vim.tbl_deep_extend("force", monokai.soda, {
          base0 = "#151617",
          base1 = "#191a1b",
          base2 = "#1b1d1e",
          base3 = "#242629",
          base4 = "#303236",
        })

        monokai.setup({
          palette = palette,
          custom_hlgroups = {
            Normal = { fg = palette.white, bg = palette.base2 },
            NormalNC = { fg = palette.white, bg = palette.base2 },
            TabLineSel = { fg = palette.base2, bg = palette.base8 },
          },
        })
      end,
    },
    "petertriho/nvim-scrollbar",
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      opts = {},
    },
    "tpope/vim-repeat",
    "tpope/vim-surround",
    "terryma/vim-multiple-cursors",
    "triglav/vim-visual-increment",
    {
      "andymass/vim-matchup",
      event = { "BufReadPre", "BufNewFile" },
      init = function()
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
        vim.g.matchup_treesitter_enabled = 1
      end,
    },
    {
      "ctrlpvim/ctrlp.vim",
      cmd = { "CtrlP", "CtrlPBuffer", "CtrlPMixed", "CtrlPMRU" },
      keys = {
        { "<C-p>", "<cmd>CtrlP<cr>", desc = "CtrlP" },
      },
      init = function()
        vim.g.ctrlp_custom_ignore = {
          dir = [[\v[\/](\.(git|hg|svn)|node_modules)$]],
          file = [[\v\.(exe|so|dll|swp|zip|7z|rar|gz|xz|apk|dmg|iso|jpg|png|pdf)$]],
        }
      end,
    },
    "chr4/nginx.vim",
    "PProvost/vim-ps1",
    "cespare/vim-toml",
    {
      "fs111/pydoc.vim",
      ft = "python",
      init = function()
        vim.g.pydoc_open_cmd = "vsplit"
        vim.g.pydoc_cmd = "python -m pydoc"
      end,
    },

    {
      "mason-org/mason.nvim",
      --cmd = { "MasonInstall", },
      opts = {},
    },
    {
      "neovim/nvim-lspconfig",
      lazy = false,
      keys = {
        { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
        { "gy", vim.lsp.buf.type_definition, desc = "Go to type definition" },
        { "K", vim.lsp.buf.hover, desc = "Hover documentation" },
        { "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
        { "<C-k>", vim.lsp.buf.signature_help, mode = { "i", "n", }, desc = "Signature help" },
        { "<leader>rn", vim.lsp.buf.rename, desc = "Rename symbol" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code actions" },
        { "gr", vim.lsp.buf.references, desc = "Find references" },
        { "[g", function() vim.diagnostic.jump({ float = true, count = -1 }) end, desc = "Previous diagnostic" },
        { "]g", function() vim.diagnostic.jump({ float = true, count =  1 }) end, desc = "Next diagnostic" },
        { "<leader>e", vim.diagnostic.open_float, desc = "Open diagnostic float" },
        { "<leader>dl", vim.diagnostic.setloclist, desc = "Open diagnostic list" },
      },
      init = function()
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "qf",
          callback = function()
            vim.keymap.set("n", "<C-t>", "<C-w><CR><C-w>T", { buffer = true, desc = "Open in new tab" })

            vim.keymap.set("x", "<C-t>", function()
              local meta = vim.fn.getqflist({ context = 1 })
              local idx = vim.fn.line(".")
              vim.cmd("tab cc " .. idx)  -- Opens the reference item in a new tab
              -- Only run if this specific quickfix list was created by your 'gr' mapping
              if meta.context and meta.context.is_lsp_refs == true then
                local idx = vim.fn.line(".")
                vim.cmd("cclose")          -- Closes the quickfix window (CoC style)
                vim.cmd("tab cc " .. idx)  -- Opens the reference item in a new tab
              else
                -- Fallback: passes <C-t> back to Neovim for non-LSP lists
                --local key = vim.api.nvim_replace_termcodes("<C-t>", true, true, true)
                --vim.api.nvim_feedkeys(key, "n", false)
              end
            end, { buffer = true, silent = true, desc = "LSP open reference in tab" })
          end,
        })

        vim.opt.completeopt = { "menu", "menuone", "noselect" }

        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then return end

            -- Enable Neovim's native trigger mechanism (e.g. typing .)
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

            -- 3. FIX: Bind Ctrl+n and Ctrl+p to invoke the modern completion engine manually
            vim.keymap.set('i', '<C-n>', function()
              vim.lsp.completion.get()
            end )
            -- Also enable a manual trigger fallback for convenience
            vim.keymap.set('i', '<C-Space>', function()
              vim.lsp.completion.get()
            end )
          end,
        })
      end,
    },

    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          map('n', '<leader>gs', gitsigns.stage_hunk)
          map('n', '<leader>gr', gitsigns.reset_hunk)

          map("n", "<leader>gn", function()
            if vim.wo.diff then
              vim.cmd.normal({ "<leader>gn", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end, { desc = "Next git hunk" })

          map("n", "<leader>gp", function()
            if vim.wo.diff then
              vim.cmd.normal({ "<leader>gp", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end, { desc = "Previous git hunk" })
        end,
      },
    },
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      dependencies = { "auditview.nvim" },
      cmd = { "NvimTreeToggle" },
      keys = {
        { "<F10>", "<cmd>NvimTreeToggle<CR>", mode = "n", desc = "Toggle NvimTree" },
        { "<F10>", "<Esc><cmd>NvimTreeToggle<CR>", mode = "i", desc = "Toggle NvimTree" },
      },
      init = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
      end,
      opts = {
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 24,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          custom = {
            "__pycache__",
            "\\.o$",
            "\\.pyc$",
            "\\~$",
            "node_modules",
            "\\.dSYM$",
            "\\.class$",
          },
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          api.config.mappings.default_on_attach(bufnr)
          vim.keymap.set("n", "<MiddleRelease>", api.node.open.tab, opts("Open: New Tab"))
        end,
      },
      config = function(_, opts)
        opts.renderer.decorators = {
          "Git", "Open", "Hidden", "Modified",
          "Bookmark", "Diagnostics", "Copied",
          require("auditview.integrations.nvim_tree").setup(),
          "Cut",
        }
        require("nvim-tree").setup(opts)
      end,
    },
    {
      "junegunn/vim-easy-align",
      keys = {
        { "<CR>", "<Plug>(EasyAlign)", mode = "v", desc = "EasyAlign" },
      },
    },
    {
      "hedyhli/outline.nvim",
      cmd = { "Outline", "OutlineOpen" },
      keys = {
        { "<F8>", "<cmd>Outline<CR>", mode = "n", desc = "Outline symbols" },
      },
      opts = {},
    },
    {
      "mileszs/ack.vim",
      cmd = { "Ack", "AckAdd", "AckFromSearch" },
      init = function()
        if vim.fn.executable("ag") == 1 or vim.fn.executable("ag.exe") == 1 then
          vim.g.ackprg = "ag --vimgrep"
        end
      end,
    },
    {
      "ggml-org/llama.vim",
      cmd = { "LlamaEnable", "LlamaDisable", "LlamaToggle" },
      init = function()
        vim.g.llama_config = {
          endpoint_fim = vim.env.LLAMA_ENDPOINT_FIM or "http://127.0.0.1:1234/infill",
          endpoint_inst = vim.env.LLAMA_ENDPOINT_INST or "http://127.0.0.1:1234/v1/chat/completions",
          n_predict = 256,
          show_info = 2,
          keymap_fim_trigger = "",
          keymap_fim_accept_full = "",
          keymap_fim_accept_line = "",
        }
      end,
    },

    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        local treesitter = require("nvim-treesitter")

        vim.api.nvim_create_user_command("TSInstallConfigured", function()
          treesitter.install(treesitter_parsers)
        end, { desc = "Install configured Treesitter parsers" })

        vim.api.nvim_create_autocmd("FileType", {
          pattern = {
            "vue",
            "pug",
            "scss",
            "css",
            "html",
            "javascript",
            "typescript",
            "lua",
            "vim",
            "toml",
            "go",
            "python",
            "c",
            "cpp",
          },
          callback = function()
            pcall(vim.treesitter.start)
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end,
        })
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-context",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      opts = {
        max_lines = 4,
        min_window_height = 25,
        mode = "cursor",
        separator = "─",
      },
    },

    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      opts = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj
        keymaps = {
          -- "af" selects the entire function definition
          ["af"] = "@function.outer",
          -- "if" selects only the contents inside the function
          ["if"] = "@function.inner",
          -- You can also add class selections
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
        -- Force line-wise visual selection (V) for entire functions
        selection_modes = {
          ['@function.outer'] = 'V',
        },
      },
      config = function(_, opts)
        local keymaps = opts.keymaps
        opts.keymaps = nil

        require("nvim-treesitter-textobjects").setup(opts)

        local select = require("nvim-treesitter-textobjects.select").select_textobject

        for lhs, query in pairs(keymaps) do
          vim.keymap.set({ "x", "o" }, lhs, function()
            select(query, "textobjects")
          end)
        end
      end,
    },

    {
      dir = "/home/inndy/auditview-nvim/nvim",
      name = "auditview.nvim",
      event = "BufReadPre",
      cmd = {
        "AuditviewMark", "AuditviewUnmark", "AuditviewProgress",
        "AuditviewRefresh", "AuditviewSessionReset",
      },
      keys = {
        { "<leader>am", mode = { "n", "x" }, desc = "auditview: mark reviewed" },
        { "<leader>au", mode = { "n", "x" }, desc = "auditview: unmark" },
      },
      opts = {
        base_url = "http://127.0.0.1:5599",
      },
    },
  },
  checker = { enabled = true },
})

vim.lsp.config("clangd", {
  filetypes = { "c", "cpp", "objc", "objcpp" },
})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
})

vim.lsp.config("pylsp", {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          maxLineLength = 180,
        },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
      },
    },
  },
})

vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        typeCheckingMode = "basic",
      },
    },
  },
})

vim.lsp.enable({ "clangd", "pyright", "gopls", "csharp_ls", })

vim.opt.autoindent = true
vim.opt.backup = false
vim.opt.colorcolumn = { 100 }
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.fileencodings = "utf-8,default,big5,ucs-bom,latin1"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.scrolloff = 3
vim.opt.shiftwidth = 4
vim.opt.showcmd = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabpagemax = 100
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.wildmenu = true
vim.opt.writebackup = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.colorcolumn = { 80 }
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "html",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.opt_local.expandtab = true
  end,
})

vim.keymap.set({ "n", "i" }, "<C-l>", function()
  vim.cmd.nohlsearch()
end, { desc = "Clear search highlight" })

vim.keymap.set("n", "<Tab>", "gt", { desc = "Next tab" })
vim.keymap.set("n", "<S-Tab>", "gT", { desc = "Previous tab" })
vim.keymap.set("n", "<A-]>", "gt", { desc = "Next tab" })
vim.keymap.set("n", "<A-[>", "gT", { desc = "Previous tab" })

vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Move to right window" })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })

vim.g.surround_33 = "<!-- \r -->" -- '!'
vim.g.surround_42 = "/* \r */" -- '*'

local is_gui = vim.fn.has("gui_running") == 1 or vim.g.neovide == true

if vim.fn.executable("win32yank.exe") == 1 then
  vim.g.clipboard = "win32yank"
elseif not is_gui and (vim.env.SSH_TTY or vim.env.SSH_CONNECTION) then
  vim.g.clipboard = "osc52"
end

vim.cmd([[
  highlight ExtraWhitespace ctermbg=red guibg=red

  augroup ExtraWhitespace
    autocmd!
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()
  augroup END
]])

if is_gui then
  if vim.loop.os_uname().sysname == "Windows_NT" then
    -- insert mode: ctrl-shift-v
    vim.keymap.set("i", "<C-S-v>", "<C-r>+", { noremap = true, silent = true, desc = "Paste from clipboard" })
    vim.opt.guifont = "IntoneMono Nerd Font,Cascadia Mono NF,Intel One Mono,Cascadia Mono:h12"
  end
  if vim.loop.os_uname().sysname == "Darwin" then
    -- insert mode: command-v
    vim.keymap.set("i", "<D-v>", "<C-r>+", { noremap = true, silent = true, desc = "Paste from clipboard" })
    vim.opt.guifont = "IntoneMono Nerd Font,InconsolataGo Nerd Font Mono:h18"
  end
end

-- vim: set et sw=2 ft=lua :
