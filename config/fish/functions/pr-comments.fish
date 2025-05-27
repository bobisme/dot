function pr-comments
    set term_width (tput cols 2>/dev/null; or echo 80)

    gh api repos/:owner/:repo/pulls/$argv[1]/comments | jq -r '.[] | @base64' | while read encoded
        set decoded (echo $encoded | base64 -d)
        set diff_hunk (echo $decoded | jq -r '.diff_hunk // ""')

        printf "%s%s%s\n" (tput setaf 8) (string repeat -n "$term_width" '─') (tput sgr0)
        echo "$decoded" | jq -r .path
        echo
        if test -n "$diff_hunk"
            echo "$decoded" | jq -r .diff_hunk | bat --language diff --style=plain
        else
            echo "No diff hunk"
        end
        echo
        echo "┏━ "(set_color blue)"@"(echo "$decoded" | jq -r .user.login)" ━ "(echo "$decoded" | jq -r .updated_at)(set_color normal)
        echo "$decoded" | jq -r .body | fmt -w 80 | bat --language md --style=plain | sed 's/^/┃ /'
        echo "┗━ "
        echo
    end
end
