-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function custom()
  local keyset = vim.keymap.set

  keyset("i", "jj", "<Esc>", { silent = true })
  keyset("i", "jk", "<Esc>:w<CR>", { silent = true })
  -- keyset("n", "<A-h>", "^", { silent = true })
  -- keyset("n", "<A-l>", "$", { silent = true })

  keyset("v", "<leader>l", ":<C-u>lua AddConsoleLog()<CR>", { noremap = true, silent = true })
  keyset("n", "<leader>l", "viw:<C-u>lua AddConsoleLog()<CR>", { noremap = true, silent = true })

  -- 生成随机颜色的函数
  local function generate_random_color()
    local hex = "0123456789ABCDEF"
    local color = "#"
    for _ = 1, 6 do
      local index = math.random(1, 16)
      color = color .. hex:sub(index, index)
    end
    return color
  end

  -- 定义函数 AddConsoleLog
  function AddConsoleLog()
    -- 获取视觉模式下选中的文本
    local start_line, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
    local end_line, end_col = unpack(vim.fn.getpos("'>"), 2, 3)
    local selected_text = vim.fn.getline(start_line, end_line)

    if #selected_text == 0 then
      return
    end

    if #selected_text == 1 then
      selected_text = selected_text[1]:sub(start_col, end_col)
    else
      selected_text[1] = selected_text[1]:sub(start_col)
      selected_text[#selected_text] = selected_text[#selected_text]:sub(1, end_col)
      selected_text = table.concat(selected_text, "\n")
    end

    -- 生成随机颜色
    local random_color = generate_random_color()

    -- 获取行号
    local line_number = vim.fn.line(".")

    -- 构造要插入的 console.log 语句
    local line_to_insert = 'console.log("%c Line:'
      .. line_number
      .. " 🥛 "
      .. selected_text
      .. '", "color:'
      .. random_color
      .. '", '
      .. selected_text
      .. ");"

    -- 将插入行的命令送入命令行
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("o" .. line_to_insert .. "<Esc>", true, false, true),
      "n",
      true
    )
  end
end

local function coc()
  -- https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.lua

  -- Some servers have issues with backup files, see #649

  vim.opt.backup = false
  vim.opt.writebackup = false

  -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
  -- delays and poor user experience
  vim.opt.updatetime = 300

  -- Always show the signcolumn, otherwise it would shift the text each time
  -- diagnostics appeared/became resolved
  vim.opt.signcolumn = "yes"

  local keyset = vim.keymap.set
  -- Autocomplete
  function _G.check_back_space()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
  end

  -- Use Tab for trigger completion with characters ahead and navigate
  -- NOTE: There's always a completion item selected by default, you may want to enable
  -- no select by setting `"suggest.noselect": true` in your configuration file
  -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
  -- other plugins before putting this into your config
  local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
  keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
  keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

  -- Make <CR> to accept selected completion item or notify coc.nvim to format
  -- <C-g>u breaks current undo, please make your own choice
  keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

  -- Use <c-j> to trigger snippets
  keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
  -- Use <c-space> to trigger completion
  keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

  -- Use `[g` and `]g` to navigate diagnostics
  -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
  keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
  keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

  -- GoTo code navigation
  -- keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
  keyset("n", "gd", "<cmd>Telescope coc definitions<cr>", { silent = true })
  keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
  keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
  keyset("n", "gr", "<cmd>Telescope coc references<cr>", { silent = true })

  -- Use K to show documentation in preview window
  function _G.show_docs()
    local cw = vim.fn.expand("<cword>")
    if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
      vim.api.nvim_command("h " .. cw)
    elseif vim.api.nvim_eval("coc#rpc#ready()") then
      vim.fn.CocActionAsync("doHover")
    else
      vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
    end
  end
  keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })

  -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
  vim.api.nvim_create_augroup("CocGroup", {})
  vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold",
  })

  -- Symbol renaming
  keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

  -- Formatting selected code
  keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
  keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

  -- Setup formatexpr specified filetype(s)
  vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s).",
  })

  -- Update signature help on jump placeholder
  vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder",
  })

  -- Apply codeAction to the selected region
  -- Example: `<leader>aap` for current paragraph
  local opts = { silent = true, nowait = true }
  keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
  keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

  -- Remap keys for apply code actions at the cursor position.
  keyset("n", "<leader>ca", "<Plug>(coc-codeaction-cursor)", opts)
  -- Remap keys for apply source code actions for current file.
  keyset("n", "<leader>cA", "<Plug>(coc-codeaction-source)", opts)
  -- Apply the most preferred quickfix action on the current line.
  keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

  -- Remap keys for apply refactor code actions.
  keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
  keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
  keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

  -- Run the Code Lens actions on the current line
  keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

  -- Map function and class text objects
  -- NOTE: Requires 'textDocument.documentSymbol' support from the language server
  keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
  keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
  keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
  keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
  keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
  keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
  keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
  keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)

  -- Remap <C-f> and <C-b> to scroll float windows/popups
  ---@diagnostic disable-next-line: redefined-local
  local opts = { silent = true, nowait = true, expr = true }
  keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
  keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
  keyset("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
  keyset("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
  keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
  keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

  -- Use CTRL-S for selections ranges
  -- Requires 'textDocument/selectionRange' support of language server
  -- keyset("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
  -- keyset("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })

  -- Add `:Format` command to format current buffer
  vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

  -- " Add `:Fold` command to fold current buffer
  vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = "?" })

  -- Add `:OR` command for organize imports of the current buffer
  vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

  -- Add (Neo)Vim's native statusline support
  -- NOTE: Please see `:h coc-status` for integrations with external plugins that
  -- provide custom statusline: lightline.vim, vim-airline
  vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

  -- Mappings for CoCList
  -- code actions and coc stuff
  ---@diagnostic disable-next-line: redefined-local
  local opts = { silent = true, nowait = true }
  -- Show all diagnostics
  -- keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
  -- Manage extensions
  -- keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
  -- Show commands
  -- keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
  -- Find symbol of current document
  -- keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
  -- Search workspace symbols
  -- keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
  -- Do default action for next item
  keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
  -- Do default action for previous item
  keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
  -- Resume latest coc list
  keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)
end

custom()
if not vim.g.vscode then
  coc()
end
