function yayf -d "fuzzy find yay packages"
    yay -Slq | fzf --multi --preview 'yay -Si {1}' \
        --height "~30" \
        --preview-window "up,~22,border-horizontal" \
        | xargs -ro yay -S
end
