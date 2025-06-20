require("telescope").setup({})

vim.api.nvim_set_keymap("n", "<leader>f", ":Telescope find_files<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>g", ":Telescope live_grep<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>b", ":Telescope buffers<cr>", { noremap = true })

return {
  { "nvim-telescope/telescope.nvim" }
}
