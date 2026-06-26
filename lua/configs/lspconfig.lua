require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "terraformls", "yamlls", "helm_ls", "pyright" }
vim.lsp.enable(servers)

-- Java - per-project workspace directory based on cwd name
vim.lsp.config("jdtls", {
  cmd = {
    "jdtls",
    "-data",
    vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
  },
})
vim.lsp.enable("jdtls")

-- read :h vim.lsp.config for changing options of lsp servers
