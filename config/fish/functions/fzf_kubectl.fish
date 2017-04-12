function fzf_kubectl
    set -l dir (commandline -t)
    set dir (eval "printf '%s' $dir")
    set -q FZF_KUBE_RESOURCES
        or set -l FZF_KUBE_RESOURCES 'pods,services,deployments,secrets,nodes'
    set -q FZF_CTRL_K_COMMAND; or set -l FZF_CTRL_K_COMMAND "
    kubectl get $FZF_KUBE_RESOURCES -o name"
    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    begin
        set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_K_OPTS"
        eval "$FZF_CTRL_K_COMMAND | fzf -m" | while read -l r
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
