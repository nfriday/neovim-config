require "nvchad.autocmds"

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*/templates/*.yaml", "*/templates/*.yml" },
  callback = function()
    vim.bo.filetype = "helm"
  end,
})

vim.api.nvim_create_user_command("Rename", function(args)
  local old = vim.api.nvim_buf_get_name(0)
  local new = vim.fn.fnamemodify(old, ":h") .. "/" .. args.args
  vim.fn.rename(old, new)
  vim.cmd("e " .. new)
end, { nargs = 1 })

local scratch_dir = vim.fn.stdpath "cache" .. "/scratch"
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "BufLeave", "FocusLost" }, {
  callback = function()
    local path = vim.api.nvim_buf_get_name(0)
    if vim.bo.modified and path:find(scratch_dir, 1, true) then
      vim.cmd "silent! write"
    end
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      require("nvim-tree.api").tree.open()
      vim.cmd("wincmd p")
    end
  end,
})

