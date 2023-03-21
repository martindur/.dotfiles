# Neovim Cheatsheet


## Motions

### Paragraphs

* `==` - Align/indent line
* `=ap` - Align/indent paragraph (Format contiguous lines)
* `=` (v) - Align/indent selection

* `cap` - Change inside paragraph (Remove contiguous text and spaces and go to insert mode)
* `cip` - Change inside paragraph (Remove contiguous text and go to insert mode)

* `dap` - Delete current paragraph (include spaces)
* `dip` - Delete current paragraph

* `yap` - Yank current paragraph (include spaces)
* `yip` - Yank current paragraph


### Navigation (Vertical)

* `D` - Half page down
* `U` - Half page up


### Text manipulation

* `diw` - Delete word under cursor. (Works anywhere in the word)
* `ciw` - Delete word under cursor and go to insert mode. (Works anywhere in the word)

* `di(` - Delete all content between ( and ), or another encloser.
* `da(` - Delete all content between and including ( and ), or another encloser.

* `ci(` - Delete all content between ( and ), or another encloser, go to insert mode
* `ca(` - Delete all content between and including ( and ), or another encloser, go to insert mode

* `yi(` - Yank content between ( and ), or another encloser.
* `ya(` - Yank content between and including ( and ), or another encloser.


### Visual mode nicetitties

* `o` (v)- Jump-toggle between top and bottom of visual selection!
* `gA` (v) - Over a selection of numbers, this will increment them like an array
* `GA` (v) - Over a selection of numbers, this will increment them the same



## Find and replace

We can use the `:substitute` to find and replace with regex.

* `:s/pattern/replace/g` - substitute *pattern* by *replace* on current line
* `:%s/pattern/replace/g` - substitute *pattern* by *replace* in current file 
* `:%s//replace/g` - substitute *last search* by *replace* in current file 
* `:s/\(test\)/best \1` - substitute *test* with *best test* using capture groups

`s` is the substitution.
`%` makes the entire file the selection.
`g` is to replace all occurances on the same line
