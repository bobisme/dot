function clr --description 'Fuzzy-pick a Claude Code session for $PWD and prefill `claude --resume <id>`'
    set -l cwd (pwd -P)
    set -l encoded (string replace -ra '[/.]' - -- $cwd)
    set -l project_dir $HOME/.claude/projects/$encoded

    if not test -d $project_dir
        echo "clr: no Claude project dir for $cwd" >&2
        echo "  expected $project_dir" >&2
        return 1
    end

    # Sort newest first by mtime; drop the timestamp prefix
    set -l files (find $project_dir -maxdepth 1 -name '*.jsonl' -type f -printf '%T@\t%p\n' \
        | sort -k1,1nr | cut -f2-)
    if test (count $files) -eq 0
        echo "clr: no session files in $project_dir" >&2
        return 1
    end

    set -l tab (printf '\t')
    set -l cols (tput cols 2>/dev/null; or echo 100)
    set -l wrap_width (math "max(40, $cols - 4)")
    set -l c_time (set_color cyan)
    set -l c_sep (set_color brblack)
    set -l c_name (set_color yellow)
    set -l c_title (set_color brwhite)
    set -l c_id (set_color brblack)
    set -l c_dot (set_color green)
    set -l c_chev (set_color blue)
    set -l c_reset (set_color normal)
    set -l rows
    for f in $files
        set -l ep (jq -r 'select(.entrypoint != null) | .entrypoint' $f 2>/dev/null | head -n1)
        test "$ep" = sdk-cli; and continue
        set -l id (basename $f .jsonl)
        set -l human (date -d @(stat -c %Y $f) +'%Y-%m-%d %H:%M')
        set -l name (jq -r 'select(.customTitle != null) | .customTitle' $f 2>/dev/null | head -n1)
        set -l title (jq -r 'select(.aiTitle != null) | .aiTitle' $f 2>/dev/null | head -n1)
        set name (string replace -a \t ' ' -- $name)
        set title (string replace -a \t ' ' -- $title)
        set -l msg_lines (jq -r '
            select(.type == "user" and (.message.content | type) == "string")
            | .message.content | gsub("\n"; " ")
        ' $f 2>/dev/null | head -n1 | fold -s -w (math "$wrap_width - 2") | head -n2)
        set -l msg1 '<no user message>'
        set -l msg2 ''
        test (count $msg_lines) -ge 1; and set msg1 $msg_lines[1]
        test (count $msg_lines) -ge 2; and set msg2 $msg_lines[2]
        set -l asst_lines (jq -r '
            select(.type == "assistant")
            | (.message.content // []) | map(select(.type == "text") | .text) | join("")
            | select(length > 0)
            | gsub("\n"; " ")
        ' $f 2>/dev/null | tail -n1 | fold -s -w (math "$wrap_width - 2") | head -n3)
        set -l asst1 '<no assistant response>'
        set -l asst2 ''
        set -l asst3 ''
        test (count $asst_lines) -ge 1; and set asst1 $asst_lines[1]
        test (count $asst_lines) -ge 2; and set asst2 $asst_lines[2]
        test (count $asst_lines) -ge 3; and set asst3 $asst_lines[3]
        # Record: <id>\t<colored line 1>\n<msg lines>\n<dot + asst>.
        # `--with-nth=2..` hides the id; `--accept-nth=1` returns only the id on selection.
        set -l line1 (printf '%s%s%s %s·%s' $c_time $human $c_reset $c_sep $c_reset)
        if test -n "$name"; and test -n "$title"
            set line1 (printf '%s %s%s%s %s—%s %s%s%s' \
                "$line1" \
                $c_name $name $c_reset \
                $c_sep $c_reset \
                $c_title $title $c_reset)
        else if test -n "$name"
            set line1 (printf '%s %s%s%s' "$line1" $c_name $name $c_reset)
        else if test -n "$title"
            set line1 (printf '%s %s%s%s' "$line1" $c_title $title $c_reset)
        end
        set line1 (printf '%s %s%s%s' "$line1" $c_id $id $c_reset)
        set -l body_lines ''
        set -a body_lines (printf '%s❯%s %s' $c_chev $c_reset "$msg1")
        test -n "$msg2"; and set -a body_lines "  $msg2"
        set -a body_lines ''
        set -a body_lines (printf '%s●%s %s' $c_dot $c_reset "$asst1")
        test -n "$asst2"; and set -a body_lines "  $asst2"
        test -n "$asst3"; and set -a body_lines "  $asst3"
        set -l visible (string join \n -- $line1 $body_lines | string collect)
        set -a rows (printf '%s\t%s' $id "$visible" | string collect)
    end

    if test (count $rows) -eq 0
        echo "clr: no resumable sessions (all sdk-cli)" >&2
        return 1
    end

    set -l id (string join0 -- $rows | fzf \
        --read0 \
        --ansi \
        --gap \
        --delimiter=$tab \
        --with-nth=2.. \
        --accept-nth=1 \
        --query=(string join ' ' -- $argv))

    if test -z "$id"
        return 1
    end

    set -l agent (basename $PWD)-dev
    commandline --replace -- "AGENT=$agent claude --dangerously-skip-permissions --resume $id"
end
