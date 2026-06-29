return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      require("telescope").load_extension "fzf"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = { "^%.git/" },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    },
  },

  {
    "LintaoAmons/scratch.nvim",
    cmd = { "Scratch", "ScratchOpen" },
    opts = {
      scratch_file_dir = vim.fn.stdpath "cache" .. "/scratch",
      file_picker = "telescope",
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        git_ignored = false,
      },
    },
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
      },
    },
  },

  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<leader>go", mode = { "n", "v" } } },
    config = function()
      require("gitlinker").setup {
        opts = {
          action_callback = require("gitlinker.actions").open_in_browser,
        },
        mappings = "<leader>go",
      }
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "jdtls",
        "pyright",
        "terraform-language-server",
        "yaml-language-server",
        "helm-ls",
        -- Formatters
        "google-java-format",
        "ruff",
      },
    },
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = { "python" },
      handlers = {},
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "java",
        "terraform",
        "hcl",
        "yaml",
        "helm",
        "gotmpl",
        "python",
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dap, dapui = require "dap", require "dapui"
          dapui.setup()
          dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        end,
      },
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "DAP continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "DAP step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "DAP step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "DAP step out" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "DAP terminate" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "DAP toggle REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP toggle UI" },
    },
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
      { "<leader>dm", function() require("dap-python").test_method() end, desc = "DAP test method" },
      { "<leader>dM", function() require("dap-python").test_class() end, desc = "DAP test class" },
    },
    config = function()
      local mason_debugpy = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(mason_debugpy)
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },
}
