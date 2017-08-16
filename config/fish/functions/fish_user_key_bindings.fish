fzf_key_bindings

# bind ctrl-g to search git branches
bind \cg fzf_git_branches
if bind -M insert > /dev/null 2>&1
  bind -M insert \cg fzf_kubectl
end

# bind ctrl-k to search kubectl resources
bind \ck fzf_kubectl
if bind -M insert > /dev/null 2>&1
  bind -M insert \ck fzf_kubectl
end
