-- Plugin: nwiizo/marp.nvim
-- Installed via store.nvim

vim.pack.add({"https://github.com/nwiizo/marp.nvim"})

require("marp").setup {
    -- Optional configuration
    marp_command = "marp", -- default: "marp" (uses marp from PATH)
    browser = nil, -- auto-detect
    server_mode = false -- Use watch mode (-w)
}