function fzf-kubectl-resources -d "Kubernetes resources."
  # Store last token in $dir as root for the 'find' command
  set -l dir (commandline -t)
  # The commandline token might be escaped, we need to unescape it.
  set dir (eval "printf '%s' $dir")
  if [ ! -d "$dir" ]
    set dir .
  end
  # Some 'find' versions print undesired duplicated slashes if the path ends with slashes.
  set dir (string replace --regex '(.)/+$' '$1' "$dir")

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

  if [ "$dir" != . ]
    # Remove last token from commandline.
    commandline -t ""
  end
  for i in $result
    commandline -it -- (string escape $i)
    commandline -it -- ' '
  end
  commandline -f repaint
end
