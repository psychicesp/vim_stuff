return {
  -- Surround text objects: ys, cs, ds.
  {
    "tpope/vim-surround",
  },

  -- Comment/uncomment with gc.
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    main = "Comment",
    opts = {},
  },

  -- Auto-close brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- File explorer.
  {
    "nvim-tree/nvim-tree.lua",
    cmd = {
      "NvimTreeToggle",
      "NvimTreeFocus",
      "NvimTreeFindFile",
    },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    main = "nvim-tree",
    opts = {
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 32,
      },
      renderer = {
        group_empty = true,
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = true,
            git = false,
          },
        },
      },
      filters = {
        dotfiles = false,
      },
    },
  },

  -- VSCode-ish toggleable terminal.
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      [[<C-`>]],
      [[<leader>t]],
    },
    opts = {
      size = 15,
      open_mapping = [[<C-`>]],
      direction = "horizontal",
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      close_on_exit = true,
    },
  },

  -- Status line.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = false,
        theme = "auto",
        component_separators = "|",
        section_separators = "",
      },
    },
  },

  -- Broad syntax/filetype support without requiring compilers, node, python, or LSP setup.
  {
    "sheerun/vim-polyglot",
    lazy = false,
  },
}