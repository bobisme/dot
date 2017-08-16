function set-badge
  if test -z "$argv[1]"
    echo "set-badge VALUE" >&2
    return 1
  end

  printf "\e]1337;SetBadgeFormat=%s\a" (echo -n "$argv[1]" | base64)
end

