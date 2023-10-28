function fzf-kubectl-resources -d "Kubernetes resources."
  set -q FZF_KUBECTL_CMD; or set -l FZF_KUBECTL_CMD "
  kubectl get pods,deployments,nodes --no-headers -o name"
  set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
  begin
    set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --no-reverse $FZF_DEFAULT_OPTS"
    eval "$FZF_KUBECTL_CMD | "(__fzfcmd)" -m" | while read -l r; set result $result $r; end
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
