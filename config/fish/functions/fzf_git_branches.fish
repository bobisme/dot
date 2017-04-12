function fzf_git_branches
    function __fzf_git_branches
        set -l dir (commandline -t)
        set dir (eval "printf '%s' $dir")
        set -q FZF_CTRL_G_COMMAND; or set -l FZF_CTRL_G_COMMAND "git branch -v"
        set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
        begin
            set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_G_OPTS"
            eval "$FZF_CTRL_G_COMMAND | fzf -m" | cut -c 3- | awk '{print $1}' \
                | while read -l r
                    set result $result $r
                end
        end
        if [ -z "$result" ]
          commandline -f repaint
          return
        end
        for i in $result
          commandline -it -- (string escape $i)
          commandline -it -- ' '
        end
        commandline -f repaint
    end

    # bind ctrl-g to search git branches
    bind \cg __fzf_git_branches
    if bind -M insert > /dev/null 2>&1
        bind -M insert \cg fzf_kubectl
    end
end
