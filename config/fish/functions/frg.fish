function frg
    # If no pattern provided, prompt for one
    if test (count $argv) -eq 0
        read -P "Search pattern: " -l pattern
        if test -z "$pattern"
            return
        end
        set argv $pattern
    end

    # Use single quotes around the pattern to preserve it exactly
    set -l quoted_pattern (string escape -- $argv)
    set -l rg_command "rg --ignore-case --color=always --line-number --no-heading -- $quoted_pattern"

    # Debug: Show the command being executed
    echo "Executing: $rg_command" >&2

    # Execute rg and pipe directly to fzf to preserve all matches
    set -l result (
        eval $rg_command | \
        fzf --ansi \
            --color 'hl:-1:underline,hl+:-1:underline:reverse' \
            --delimiter ':' \
            --preview "bat --color=always {1} --highlight-line {2}" \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
    )

    if test -n "$result"
        set -l parts (string split : $result)
        set -l file $parts[1]
        set -l line $parts[2]
        eval $EDITOR +$line $file
    end
end
