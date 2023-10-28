function select_containers
    set -lx tags
    docker ps -a \
        | tail +2 \
        | fzf -m \
        | cut -d" " -f1 \
        | while read -l tag
            set tags $tags $tag
        end
    echo $tags
end

