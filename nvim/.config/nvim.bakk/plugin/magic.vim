" Operators

onoremap <silent> F :<C-U>normal! 0f(hviw<CR>

" operator mapping, e.g. run di( with dp, or ci( with cp
" wunderbar!!
onoremap <silent> p i(

" find a better mapping, t is used for e.g. delete to x
" onoremap <silent> t i"

" db -> delete body, e.g. delete up until return (useful in most filetypes,
" but might want to make a custom one for elixir
onoremap <silent> b /return<cr>


" EXTERNAL APPS - FLOATING TERMINAL

function! SpawnInFloatTerm(cmd)
    "let buf = term_start(a:cmd, #{hidden: 1, term_finish: 'close'})
    let buf = nvim_create_buf(v:false, v:true)
    let win = nvim_open_win(buf, v:true, {
                \ 'relative': 'editor',
    \ 'width': 200,
    \ 'height': 100,
    \ 'col': &columns/ 2 - 100,
    \ 'row': &lines / 2 - 50,
    \ 'border': 'single',
    \ 'style': 'minimal'
    \ })

    call termopen(a:cmd, {'on_exit': {job_id, exit_code, event -> nvim_win_close(win, v:true)}})
    call nvim_command('startinsert')
endfunction

nnoremap <silent> <leader>g :call SpawnInFloatTerm(['lazygit'])<CR>
nnoremap <silent> <leader>e :call SpawnInFloatTerm(['yazi'])<CR>
"TODO: Handle SQL editor - maybe rainfrog in float term? https://github.com/achristmascarl/rainfrog

function! TabOrRight()
    if search('\%#[]>)}''"]', 'n')
        return "\<right>"
    endif

    return "\<tab>"
endfunction

inoremap <expr> <Tab> TabOrRight()

function! NextLineWithEmptySpace()
    let l:save_search = @/

    execute 'normal! /\(^\n\)\@<=^.\<CR>'

    let @/ = l:save_search
endfunction


" Jumps over white space
" nnoremap j :/\v\S<cr>:nohlsearch<cr>
" nnoremap k :?\v\S<cr>:nohlsearch<cr>


" QUICKFIX

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

function! ToggleLoc()
    if empty(filter(getwininfo(), 'v:val.loclist'))
        lopen
    else
        lclose
    endif
endfunction

nnoremap <silent> qq :call ToggleQuickFix()<cr>
nnoremap <silent> qo :copen<cr>
nnoremap <silent> qc :cclose<cr>


" GIT LENS

lua <<EOF


local api = vim.api

function blameVirtText()
  local ft = vim.fn.expand('%:h:t') -- get the current file extension
  if ft == '' then -- if we are in a scratch buffer or unknown filetype
    return
  end
  if ft == 'bin' then -- if we are in nvim's terminal window
    return
  end
  api.nvim_buf_clear_namespace(0, 2, 0, -1) -- clear out virtual text from namespace 2 (the namespace we will set later)
  local currFile = vim.fn.expand('%')
  local line = api.nvim_win_get_cursor(0)
  local blame = vim.fn.system(string.format('git blame -c -L %d,%d %s', line[1], line[1], currFile))
  local hash = vim.split(blame, '%s')[1]
  local cmd = string.format("git show %s ", hash).."--format='%an | %ar | %s'"
  if hash == '00000000' then
    text = 'Not Committed Yet'
  else
    text = vim.fn.system(cmd)
    text = vim.split(text, '\n')[1]
    if text:find("fatal") then -- if the call to git show fails
      text = 'Not Committed Yet'
    end
  end
  api.nvim_buf_set_virtual_text(0, 2, line[1] - 1, {{ text,'GitLens' }}, {}) -- set virtual text for namespace 2 with the content from git and assign it to the higlight group 'GitLens'
  --api.nvim_buf_set_extmark(0, 2, line[1] - 1, {{ text,'GitLens' }}, { virt_text_pos = 'eol' }) -- set virtual text for namespace 2 with the content from git and assign it to the higlight group 'GitLens'
end

function clearBlameVirtText() -- important for clearing out the text when our cursor moves
  api.nvim_buf_clear_namespace(0, 2, 0, -1)
end

EOF

lua vim.api.nvim_command [[autocmd CursorHold   * lua blameVirtText()]]
lua vim.api.nvim_command [[autocmd CursorMoved  * lua clearBlameVirtText()]]
lua vim.api.nvim_command [[autocmd CursorMovedI * lua clearBlameVirtText()]]

set updatetime=200

hi! link GitLens Comment
