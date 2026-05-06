return {
  -- Detect tabstop/shiftwidth automatically from existing files.
  {
    "tpope/vim-sleuth",
  },

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