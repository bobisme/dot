function prs --argument-names file
    set -l select ""
    if test -n "$file"
        set select "| select(.files.[].path == \"$file\")"
    end
    gh pr list --state open \
        --json files,title,url,number,labels,author \
        --jq ".[] $select | \
            \"\(.number): \(.title) @\(.author.login)\", \
            .url, ([.labels.[] | \"(\(.name))\"] | join(\", \")), \
            (.files.[] | \"- \(.path) | +\(.additions),-\(.deletions)\"), \"\""
end
