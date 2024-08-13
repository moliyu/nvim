return {
  { "nvim-lspconfig", enabled = false },
  { "hrsh7th/nvim-cmp", enabled = false },
  {
    "neoclide/coc.nvim",
    branch = "release",
  },
  {
    "fannheyward/telescope-coc.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          coc = {
            -- theme = "ivy",
            prefer_locations = false, -- always use Telescope locations to preview definitions/declarations/implementations etc
            push_cursor_on_edit = true, -- save the cursor position to jump back in the future
            -- timeout = 3000, -- timeout for coc commands
          },
        },
      })
      require("telescope").load_extension("coc")
    end,
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       eslint = {
  --         on_attach = function(client, bufnr)
  --           vim.api.nvim_create_autocmd("BufWritePre", {
  --             buffer = bufnr,
  --             command = "EslintFixAll",
  --           })
  --         end,
  --       },
  --     },
  --   },
  -- },
}
