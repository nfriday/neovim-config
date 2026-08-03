require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("i", "jk", "<ESC>")
map({ "n", "v" }, "d", '"dd', { desc = "Delete to named register" })
map({ "n", "v" }, "D", '"dD', { desc = "Delete to end to named register" })
map({ "n", "v" }, "c", '"dc', { desc = "Change to named register" })
map({ "n", "v" }, "C", '"dC', { desc = "Change to end to named register" })
map({ "n", "v" }, "x", '"dx', { desc = "Cut char to named register" })
map({ "n", "v" }, "X", '"dX', { desc = "Cut char back to named register" })
map("n", "<leader>p", '"dp', { desc = "Paste last delete/change" })
map("n", "<leader>P", '"dP', { desc = "Paste last delete/change (before cursor)" })
map("v", "<", "<gv", { desc = "De-indent and reselect" })
map("v", ">", ">gv", { desc = "Indent and reselect" })

-- scratch buffers
map("n", "<leader>s", "<cmd>Scratch<cr>", { desc = "New scratch buffer" })
map("n", "<leader>so", "<cmd>ScratchOpen<cr>", { desc = "Open scratch buffer" })

-- treesitter context
map("n", "<leader>tc", function() require("treesitter-context").toggle() end, { desc = "Toggle treesitter context" })

-- yaml
map("n", "<leader>yk", "<cmd>YAMLYankKey +<cr>", { desc = "Yank YAML key path" })
map("n", "<leader>yf", "<cmd>YAMLTelescope<cr>", { desc = "Find YAML key (telescope)" })

-- diagnostics
map("n", "<leader>er", function()
  local bufnr, winnr = vim.diagnostic.open_float()
  if winnr then
    vim.api.nvim_set_current_win(winnr)
    vim.keymap.set("n", "<Esc>", function()
      vim.api.nvim_win_close(winnr, true)
    end, { buffer = bufnr, nowait = true })
  end
end, { desc = "Show diagnostic float" })
map("n", "<leader>ex", "<cmd>NvimTreeFocus<cr>", { desc = "NvimTree focus window" })

-- telescope pickers
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
map("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Find commands" })

-- open current file/line on GitHub (visual: selected range)
-- <leader>go is mapped by gitlinker.nvim setup in plugins/init.lua
map({ "n", "t" }, "<C-`>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggleable floating term" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

local function send_to_term(text)
  local toggle_term = function()
    require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
  end

  local function do_send(chan, buf)
    vim.fn.chansend(chan, text .. '\n')
    vim.defer_fn(function()
      local last_line = vim.api.nvim_buf_line_count(buf)
      for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.api.nvim_win_set_cursor(win, { last_line, 0 })
      end
    end, 50)
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      local chan = vim.bo[buf].channel
      if chan > 0 and vim.fn.jobwait({chan}, 0)[1] == -1 then
        local wins = vim.fn.win_findbuf(buf)
        if #wins == 0 then
          -- defer send until the float has finished opening
          toggle_term()
          vim.defer_fn(function() do_send(chan, buf) end, 100)
        else
          do_send(chan, buf)
        end
        return
      end
    end
  end
  -- No terminal yet — open one and retry after it's ready
  toggle_term()
  vim.defer_fn(function() send_to_term(text) end, 300)
end

map('n', '<F8>', function()
  send_to_term(vim.api.nvim_get_current_line())
end, { desc = 'Send line to terminal' })

map('v', '<F8>', function()
  local s = math.min(vim.fn.line("v"), vim.fn.line("."))
  local e = math.max(vim.fn.line("v"), vim.fn.line("."))
  local lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false)
  send_to_term(table.concat(lines, "\n"))
end, { desc = 'Send selection to terminal' })
