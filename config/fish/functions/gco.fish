function gco
    # Get all branches
    set branches (git branch --all | grep -v HEAD | sed "s/.* //" | sed "s#remotes/[^/]*/##" | sort -u)

    # Use fzf to select a branch
    set selected_branch (string join \n $branches | fzf --height 40% --reverse)

    # If a branch was selected, prepare the git checkout command
    if test -n "$selected_branch"
        commandline -r "git checkout $selected_branch"
        commandline -f execute
    end
end
