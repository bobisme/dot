function fzf_kubectl
  set -l dir (commandline -t)
  set dir (eval "printf '%s' $dir")
  set -l complete_command "kubectl config get-contexts -o=name"
  set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
  begin
    set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_K_OPTS"
    eval "$complete_command | fzf" | read ctx
  end
  if [ -z "$ctx" ]
    commandline -f repaint
    return
  end
  commandline 'kubectl --context='
  commandline -it -- (string escape $ctx)
  commandline -it -- ' '
  commandline -f repaint
end
