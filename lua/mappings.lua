require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "<S-Tab>", "<C-d>", { desc = "De-indent" })
map("v", "<", "<gv", { desc = "De-indent and reselect" })
map("v", ">", ">gv", { desc = "Indent and reselect" })

-- scratch buffers
map("n", "<leader>s", "<cmd>Scratch<cr>", { desc = "New scratch buffer" })
map("n", "<leader>so", "<cmd>ScratchOpen<cr>", { desc = "Open scratch buffer" })

-- telescope pickers
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
map("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Find commands" })

-- open current file/line on GitHub (visual: selected range)
-- <leader>go is mapped by gitlinker.nvim setup in plugins/init.lua
map({ "n", "t" }, "<C-`>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

local function send_to_term(text)
  local toggle_term = function()
    require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      local chan = vim.bo[buf].channel
      if chan > 0 then
        local wins = vim.fn.win_findbuf(buf)
        if #wins == 0 then toggle_term() end
        vim.fn.chansend(chan, text .. '\n')
        vim.defer_fn(function()
          local last_line = vim.api.nvim_buf_line_count(buf)
          for _, win in ipairs(vim.fn.win_findbuf(buf)) do
            vim.api.nvim_win_set_cursor(win, { last_line, 0 })
          end
        end, 50)
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
  local saved = vim.fn.getreg('z')
  local savedtype = vim.fn.getregtype('z')
  vim.cmd('noau normal! gv"zy')
  local text = vim.fn.getreg('z')
  vim.fn.setreg('z', saved, savedtype)
  send_to_term(text)
end, { desc = 'Send selection to terminal' })
