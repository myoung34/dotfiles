local function test_file()
  local neotest = require("neotest")
  neotest.run.run(vim.fn.expand("%"))
end

vim.g["test#python#pytest#file_pattern"] = [[test_.+\.py$]]

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            pytest_discover_instances = true,
          }),
        },
      })
    end,
    --keys = {
    --  { "<leader>a", "<cmd>echo \"foo\"<cr>", desc = "+testing" },
    --  { "<leader>t", desc = "+testing" },
    --  { "<leader>to", "<cmd>lua require(\"neotest\").output_panel.open()<cr>", desc = "Show test output" },
    --  { "<leader>tc", "<cmd>lua require(\"neotest\").output_panel.close()<cr>", desc = "Close test output" },
    --  { "<leader>tr", "<cmd>lua require(\"neotest\").run.run(vim.fn.expand(\"%\"))<cr><cmd>lua require(\"neotest\").output_panel.open()<cr>", desc = "Run tests" },
    --},
  },
}
