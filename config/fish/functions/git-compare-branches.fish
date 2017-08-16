function git-compare-branches
  function __help
    echo "
git-compare-branches ACTION

ACTIONS:
  both            Show branches which exist in origin and local.
  local           Show which branches which only exist locally (default).
  remote,origin   Show which branches which only exist in origin.
"
  end

  function __origin_branches
    git branch -r | \
      grep origin | \
      grep -v '>' | \
      grep -v master | \
      xargs -L1 | \
      sed 's#^[^/]*/##g'
  end

  function __local_branches
    git branch | awk '{ print $1 }' | sed '/\*/d'
  end

  function __comm
    comm $argv[1] (__local_branches | psub) (__origin_branches | psub)
  end

  function __show_both
    __comm -12
  end

  function __show_local
    __comm -23
  end

  function __show_origin
    __comm -13
  end

  switch "$argv[1]"
    case both
      __show_both
    case local
      __show_local
    case remote origin
      __show_origin
    case -h --h --help -help help
      __help
      return 0
    case '*'
      __show_local
  end
end

