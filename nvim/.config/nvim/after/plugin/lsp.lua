local lsp = require('lsp-zero')


lsp.preset('recommended')

-- No fuss setup!
--lsp.setup()

--[[lsp.ensure_installed({
	'tsserver',
	'eslint',
	'sumneko_lua',
	'rust_analyzer',
	'pyright',
})]]


lsp.setup()
