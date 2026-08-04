local function add_unique(values, value)
  if not vim.tbl_contains(values, value) then
    table.insert(values, value)
  end
end

return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.lsp = opts.sources.providers.lsp or {}

      local lsp = opts.sources.providers.lsp
      lsp.override = lsp.override or {}
      local get_completions = lsp.override.get_completions

      lsp.override.get_completions = function(source, context, callback)
        local function handle_response(response)
          if response and vim.bo[context.bufnr].filetype == "astro" then
            response.is_incomplete_forward = true

            -- The LSP source caches each client's response separately from the
            -- aggregate response above. Mark that response incomplete as well
            -- so the next character causes a real request to Astro's server.
            local cache = require("blink.cmp.sources.lsp.cache")
            for _, client in ipairs(vim.lsp.get_clients({ bufnr = context.bufnr })) do
              local entry = cache.entries[client.id]
              if entry and entry.response then
                entry.response.is_incomplete_forward = true
              end
            end
          end

          callback(response)
        end

        if get_completions then
          return get_completions(source, context, handle_response)
        end
        return source:get_completions(context, handle_response)
      end

      opts.completion = opts.completion or {}
      opts.completion.accept = opts.completion.accept or {}
      opts.completion.accept.auto_brackets = opts.completion.accept.auto_brackets or {}

      local auto_brackets = opts.completion.accept.auto_brackets
      auto_brackets.kind_resolution = auto_brackets.kind_resolution or {}
      auto_brackets.kind_resolution.blocked_filetypes = auto_brackets.kind_resolution.blocked_filetypes or {}
      add_unique(auto_brackets.kind_resolution.blocked_filetypes, "astro")

      auto_brackets.semantic_token_resolution = auto_brackets.semantic_token_resolution or {}
      auto_brackets.semantic_token_resolution.blocked_filetypes = auto_brackets.semantic_token_resolution.blocked_filetypes
        or {}
      add_unique(auto_brackets.semantic_token_resolution.blocked_filetypes, "astro")
    end,
  },
}
