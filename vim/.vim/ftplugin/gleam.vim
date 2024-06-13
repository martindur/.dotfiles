if executable('gleam')
    au User lsp_setup call lsp#register_server({
    \ 'name': 'gleam-ls',
    \ 'cmd': {server_info->['gleam', 'lsp']},
    \ 'allowlist': ['gleam'],
    \ })
endif
