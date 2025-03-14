function rgbat
    # Check if we have at least one argument (the pattern)
    if test (count $argv) -lt 1
        echo "Usage: rgbat [RG_OPTIONS] PATTERN [FILES...]"
        echo "Supported context options: -A/--after-context, -B/--before-context, -C/--context"
        return 1
    end

    # Parse out ripgrep options and find the pattern
    set rg_opts
    set pattern ""
    set files

    # Context tracking variables
    set after_context 10 # Default after-context
    set before_context 0 # Default before-context

    set i 1
    while test $i -le (count $argv)
        set arg $argv[$i]

        # Check for options
        if string match -q -- "-*" $arg
            # Handle context options specifically
            if string match -q -- -A $arg; or string match -q -- --after-context $arg
                set i (math $i + 1)
                set after_context $argv[$i]
                set rg_opts $rg_opts -A $after_context
            else if string match -q -- -B $arg; or string match -q -- --before-context $arg
                set i (math $i + 1)
                set before_context $argv[$i]
                set rg_opts $rg_opts -B $before_context
            else if string match -q -- -C $arg; or string match -q -- --context $arg
                set i (math $i + 1)
                set after_context $argv[$i]
                set before_context $argv[$i]
                set rg_opts $rg_opts -C $argv[$i]
            else
                # Pass through other options
                set rg_opts $rg_opts $arg
            end
        else if test -z "$pattern"
            # First non-option argument is the pattern
            set pattern $arg
        else
            # Remaining non-option arguments are files
            set files $files $arg
        end

        set i (math $i + 1)
    end

    # If no files specified, search current directory
    if test (count $files) -eq 0
        set files "."
    end

    # Run ripgrep and process results
    rg --json $rg_opts "$pattern" $files | jq -r 'select(.type=="match") | 
      "\(.data.path.text):\(.data.line_number):\(.data.line_number - '$before_context'):\(.data.line_number + '$after_context')"' | while read -l match
        set parts (string split ":" $match)
        set file $parts[1]
        set match_line $parts[2]
        set start_line $parts[3]
        set end_line $parts[4]

        # Ensure start_line is not negative
        if test $start_line -lt 1
            set start_line 1
        end

        bat --highlight-line $match_line --line-range=$start_line:$end_line $file
    end
end
