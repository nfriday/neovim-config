local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    terraform = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },
    java = { "google-java-format" },
    python = { "ruff_format" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = false,
  },
}

return options
