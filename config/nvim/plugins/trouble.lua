require("trouble").setup({})

vim.api.nvim_set_keymap("n", ".", ":Trouble diagnostics toggle<cr>", { noremap = true })

return {
  { "folke/trouble.nvim" }
}
