function set-badge
  printf "\e]1337;SetBadgeFormat=%s\a" (echo -n "$argv[1]" | base64)
end

