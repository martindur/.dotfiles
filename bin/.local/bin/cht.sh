#!/usr/bin/fish
set lang ~/.local/chtsh/.cht-languages
set cmd ~/.local/chtsh/.cht-commands

set selected (cat $lang $cmd | fzf)

if test -z "$selected"
    exit 0
end

read -l -P 'Query: ' query

if grep -qs "$selected" ~/.local/chtsh/.cht-languages
    set query (echo $query | tr ' ' '+')
    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    tmux neww bash -c "curl -s cht.sh/$selected-$query | less"
end
