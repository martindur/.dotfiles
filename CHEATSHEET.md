# Working Cheatsheet

A concise reminder of the fundamental tools that replace configured conveniences.

## Substitutions

| Old convenience         | Fundamental approach                  |
| ----------------------- | ------------------------------------- |
| Fuzzy file picker       | `:edit`, `:find`, netrw               |
| Fuzzy buffer picker     | `:ls`, `:buffer`, `:b#`               |
| Search-results picker   | `:grep` and quickfix                  |
| Location/history picker | Marks, jump list, change list         |
| Terminal panes          | Neovim splits and terminal buffers    |
| Terminal workspaces     | i3 workspaces                         |
| Project selector        | Shell navigation or Rofi, then `nvim` |
| Background terminal tab | Shell job control                     |
| Persistent process      | A user service                        |

## Files and Buffers

```vim
:edit path          " open a path
:find name          " search directories in 'path'
:edit .             " browse with netrw
:Explore            " browse from the current file

:ls                 " list buffers
:buffer name        " switch buffer
:bnext / :bprev     " move through buffers
:b#                 " switch to the alternate buffer
:bd! #              " delete the alternate buffer and its terminal job

gf                  " open the filename under the cursor
<C-w>f              " open it in a split
```

Launch Neovim from the project root so that relative paths, `:find`, `:grep`,
and external commands share a useful working directory.

```vim
:pwd                " show working directory
:cd path            " change global working directory
:lcd path           " change it for the current window
:tcd path           " change it for the current tab
```

## Locations

```vim
ma                  " set buffer-local mark a
`a                  " jump to its exact position
'a                  " jump to its line
mA                  " set cross-file mark A
`A                  " jump to it
:marks              " inspect marks

<C-o>               " older position in the jump list
<C-i>               " newer position in the jump list
``                  " previous exact jump position
''                  " previous jump line
g;                  " previous change
g,                  " next change
```

Lowercase marks belong to a buffer. Uppercase marks can return to another
buffer, including a hidden terminal buffer, until that buffer is deleted.

## Search and Quickfix

```vim
/pattern            " search the current buffer
n / N               " next / previous match

:grep pattern       " search files with 'grepprg'
:copen              " inspect results
:cnext / :cprev     " move through results
:cclose             " close the quickfix window
```

Quickfix is a persistent list of locations used by searches, builds, and
other commands.

## Windows and Terminals

```vim
:split              " horizontal window
:vsplit             " vertical window
:terminal           " terminal in the current window
:vsplit | terminal  " terminal in a new split

<C-w>h/j/k/l        " move between windows
<C-w>q              " close a window
<C-w>=              " equalize window sizes
<C-w>+/-            " change height
<C-w>< / <C-w>>     " change width
```

From Terminal mode:

```vim
<C-\><C-n>          " enter Terminal-Normal mode
i                   " resume terminal input
```

A terminal is a buffer. Closing its window can leave its process running;
deleting its buffer terminates the process. Terminal processes do not survive
exiting Neovim.

## Commands and Filters

```vim
:!command                 " run a one-off command
:terminal command         " run an interactive command
:make                     " build and populate quickfix
:read !command            " insert output below the current line
:0read !command           " insert output at the start
:'<,'>!command             " replace selected text with filtered output
:'<,'>write !command       " send selected text without replacing it
```

Examples:

```vim
:%!jq .                   " format a JSON buffer
:'<,'>!sort -u            " sort and deduplicate selected lines
:'<,'>!pg_format          " format selected SQL
```

## Shell Navigation

```bash
cd -                      # previous directory
pushd path                 # visit a directory and remember the current one
popd                       # return to the remembered directory
dirs -v                    # inspect the directory stack

find . -type f -name '*.lua'
find . -type f -iname '*config*'
rg --files                 # project files, respecting ignore files
rg pattern                 # search file contents
```

Quote `find` patterns so the shell does not expand them first.

## Jobs and Processes

```bash
command &                 # start a background job
jobs                      # list this shell's jobs
<C-z>                     # stop the foreground job
bg %1                     # continue job 1 in the background
fg %1                     # return job 1 to the foreground
kill %1                   # signal a shell job

ps                        # inspect processes
kill PID                  # signal a process
```

Jobs belong to their shell. Use a user service for a process that must be
supervised or survive its terminal; use a terminal multiplexer only when an
interactive terminal must be reattached later.

## PostgreSQL

Use a scratch SQL buffer for queries and `psql` as the database interface.

```vim
:enew
:setfiletype sql
:terminal psql service=dev
:'<,'>write !psql service=dev
:%write !psql -X -v ON_ERROR_STOP=1 service=dev
```

Useful interactive `psql` commands:

```text
\conninfo           connection information
\l                  databases
\dn                 schemas
\dt                 tables
\d name             describe a relation
\x                  toggle expanded rows
\timing             toggle query timing
\?                  psql command help
\h SELECT           SQL syntax help
```

Keep production credentials in 1Password. Invoke production access through a
dedicated command that retrieves credentials at runtime rather than recording
connection strings in this repository or passing secrets as command-line
arguments.
