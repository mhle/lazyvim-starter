return {
  {
    "stevearc/conform.nvim",
    init = function()
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = { ".env", ".env.prod", "*/.env", "*/.env.prod" },
        callback = function(event)
          vim.b[event.buf].autoformat = false
        end,
      })
    end,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      opts.formatters_by_ft.sh = function(bufnr)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
        if filename == ".env" or filename == ".env.prod" then
          return {}
        end

        return { "shfmt" }
      end
    end,
  },
}
