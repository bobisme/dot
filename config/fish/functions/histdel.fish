function histdel
    # Check if fzf is installed
    if not command -q fzf
        echo "Error: fzf is not installed. Please install it first."
        return 1
    end

    # Create a backup of the history file
    set -l hist_file $HOME/.local/share/fish/fish_history
    set -l backup_file "$hist_file.backup"
    cp $hist_file $backup_file
    echo "Created backup at $backup_file"

    # Get fish version for compatibility checks
    set -l FISH_MAJOR (echo $version | cut -f1 -d.)
    set -l FISH_MINOR (echo $version | cut -f2 -d.)

    # Merge history from other sessions
    if test -z "$fish_private_mode"
        builtin history merge
    end

    # Set up FZF options to match your Ctrl+R styling
    set -lx FZF_DEFAULT_OPTS "--multi --height 40% --reverse --scheme=history --bind=ctrl-r:toggle-sort --wrap-sign='\"\t\"↳ ' --highlight-line"

    # Temporary file for selections
    set -l selected_file (mktemp)

    # Use history -z for multi-line support (for fish 2.4.0+)
    if [ "$FISH_MAJOR" -gt 2 -o \( "$FISH_MAJOR" -eq 2 -a "$FISH_MINOR" -ge 4 \) ]
        if type -q perl
            # Use the exact same approach as your Ctrl+R implementation
            builtin history -z --reverse |
                command perl -0 -pe 's/^/$.\t/g; s/\n/\n\t/gm' |
                fzf --tac --read0 --print0 --query="" >$selected_file
        else
            # Fallback if perl is not available
            builtin history -z | fzf --read0 --print0 --query="" >$selected_file
        end
    else
        # Fallback for older fish versions
        builtin history | fzf --query="" >$selected_file
    end

    # Check if any commands were selected
    if not test -s $selected_file
        echo "No commands selected."
        rm $selected_file
        return 0
    end

    # Process and delete selected entries
    set -l delete_count 0

    if [ "$FISH_MAJOR" -gt 2 -o \( "$FISH_MAJOR" -eq 2 -a "$FISH_MINOR" -ge 4 \) ]
        # For fish 2.4.0+ with null-terminated strings
        if type -q perl
            # Process perl-formatted selections
            cat $selected_file | command perl -0 -pe 's/^\d*\t//gm' |
                while read -lz cmd
                    if test -n "$cmd"
                        history delete --exact --case-sensitive -- "$cmd"
                        set delete_count (math $delete_count + 1)
                    end
                end
        else
            # Process standard null-terminated selections
            cat $selected_file |
                while read -lz cmd
                    if test -n "$cmd"
                        history delete --exact --case-sensitive -- "$cmd"
                        set delete_count (math $delete_count + 1)
                    end
                end
        end
    else
        # For older fish versions
        cat $selected_file |
            while read -l cmd
                if test -n "$cmd"
                    history delete --exact --case-sensitive -- "$cmd"
                    set delete_count (math $delete_count + 1)
                end
            end
    end

    # Clean up
    rm $selected_file

    echo "Deleted $delete_count commands from history."
end
