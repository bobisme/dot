function tldrf
    tldr --list | fzf --preview 'tldr --color=always {1}' \
        --preview-window up,80%,border-horizontal \
        | xargs tldr --color=always | bat -p
end
