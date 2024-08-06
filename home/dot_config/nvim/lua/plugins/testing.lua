local function test_file()
  local neotest = require("neotest")
  neotest.run.run(vim.fn.expand("%"))
end

vim.g["test#python#pytest#file_pattern"] = [[test_.+\.py$]]

return {
  {
    "vim-test/vim-test",
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-go",
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
            runner = "pytest",
          }),
          require("neotest-go")({
            recursive_run = true,
          }),
        },
      })
    end,
  },
}
