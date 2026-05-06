local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim:\n" .. output)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("user.plugins", {
  change_detection = {
    notify = false,
  },

  install = {
    colorscheme = { "habamax" },
  },

  checker = {
    enabled = false,
  },

  -- Keep this repo dependency-light. Do not require luarocks unless you add
  -- plugins that actually need rockspec support.
  pkg = {
    sources = { "lazy" },
  },
})