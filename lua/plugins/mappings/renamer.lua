require("which-key").add {
  {
    "<leader>ra",
    mode = { "n", "v" },
    function()
      require("renamer").rename()
    end,
    noremap = true,
    silent = true,
  },
  {
    "F2",
    mode = { "i" },
    function()
      require("renamer").rename()
    end,
    noremap = true,
    silent = true,
  },
}
