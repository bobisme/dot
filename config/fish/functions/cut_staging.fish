function cut_staging
  set -l week_number (printf "%02d" (math (date "%W") + 1))
  set -l branch_name "staging/$week_number"

  git checkout master
    and git pull origin --ff-only master
    and git checkout -b $branch_name
    or return

  read -l -p "Push $branch_name? [y/N] " push_branch
  switch $push_branch
    case Y y Yes yes YES
      git push origin $branch_name -u
    case '*'
      echo Did not push $branch_name
  end
end