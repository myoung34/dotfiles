-- bootstrap lazy.nvim, LazyVim and your plugins
vim.g.mapleader = ","
vim.keymap.set("n", "<leader>to", "<cmd>lua require(\"neotest\").output_panel.open()<cr>", { desc = "Show test output" })
vim.keymap.set("n", "<leader>tc", "<cmd>lua require(\"neotest\").output_panel.close()<cr>", { desc = "Close test output" })
vim.keymap.set("n", "<leader>tr", "<cmd>lua require(\"neotest\").run.run(vim.fn.expand(\"%\"))<cr><cmd>lua require(\"neotest\").output_panel.open()<cr>", { desc = "Run tests" })

require("config.lazy")
