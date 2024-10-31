require("nvim-tree").setup({})

vim.api.nvim_set_keymap("n", ",", ":NvimTreeOpen<cr>", {noremap=true})

return {
    { "nvim-tree/nvim-tree.lua" }
}
