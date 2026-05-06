local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Highlight text after yanking",
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  desc = "Use 2-space indentation for common web/config formats",
  pattern = {
    "css",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "lua",
    "typescript",
    "typescriptreact",
    "yaml",
  },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Still hooked on VSCode and this makes me less homesick
vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  desc = "Open nvim-tree on startup",
  callback = function()
    local api_ok, api = pcall(require, "nvim-tree.api")
    if not api_ok then
      return
    end

    -- Do not open the tree for special startup cases.
    local first_arg = vim.fn.argv(0)
    if first_arg ~= "" and vim.fn.isdirectory(first_arg) == 0 then
      return
    end

    api.tree.open()
  end,
})