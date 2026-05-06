local map = vim.keymap.set

-- Core quality-of-life mappings
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })

-- <leader> is currently Space, set in options.lua.
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Split navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })

-- Still hooked on VSCode and this makes me less homesick.
-- These mappings imitate familiar VSCode editing shortcuts.

-- Shift+Tab outdents in Normal, Insert, and Visual mode.
map("n", "<S-Tab>", "<<", { desc = "Outdent line" })
map("i", "<S-Tab>", "<C-d>", { desc = "Outdent line" })
map("v", "<S-Tab>", "<gv", { desc = "Outdent selection" })

-- Alt+Up / Alt+Down move the current line or visual selection.
map("n", "<A-Up>", ":m .-2<cr>==", { desc = "Move line up" })
map("n", "<A-Down>", ":m .+1<cr>==", { desc = "Move line down" })

map("i", "<A-Up>", "<Esc>:m .-2<cr>==gi", { desc = "Move line up" })
map("i", "<A-Down>", "<Esc>:m .+1<cr>==gi", { desc = "Move line down" })

map("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })

-- Shift+Alt+Up / Shift+Alt+Down copy the current line or visual selection.
map("n", "<A-S-Up>", "yyP", { desc = "Copy line up" })
map("n", "<A-S-Down>", "yyp", { desc = "Copy line down" })

map("i", "<A-S-Up>", "<Esc>yyPgi", { desc = "Copy line up" })
map("i", "<A-S-Down>", "<Esc>yypgi", { desc = "Copy line down" })

map("v", "<A-S-Up>", "y`<Pgv", { desc = "Copy selection up" })
map("v", "<A-S-Down>", "y`>pgv", { desc = "Copy selection down" })

-- VSCode-ish terminal toggle.
map("n", "<F12>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
map("i", "<F12>", "<Esc><cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
map("t", "<F12>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })

map("n", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
map("i", "<leader>t", "<Esc><cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
map("t", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })