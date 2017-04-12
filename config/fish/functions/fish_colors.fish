function fish_colors --description="Print the fish colors."
  set -l colors \
    fish_color_normal \
    fish_color_command \
    fish_color_quote \
    fish_color_redirection \
    fish_color_end \
    fish_color_error \
    fish_color_param \
    fish_color_comment \
    fish_color_match \
    fish_color_search_match \
    fish_color_operator \
    fish_color_escape \
    fish_color_cwd \
    fish_color_autosuggestion \
    fish_color_user \
    fish_color_host \
    fish_pager_color_prefix \
    fish_pager_color_completion \
    fish_pager_color_description \
    fish_pager_color_progress \
    fish_pager_color_secondary

  function _print_varcolor
    set -l color_var $argv[1]
    set -l color (set_color $$color_var)
    set -l normal (set_color normal)
    printf "%s|%s%s\n" \$$color_var $color "$$color_var$normal"
  end

  begin
    for color in $colors
      _print_varcolor $color
    end
  end | column -t -s '|'

  set -l simple blue green red magenta yellow cyan white black
  begin
    for color in $simple
      set -l brcolor br$color
      echo (set_color $color)$color(set_color normal)
      echo (set_color $brcolor)$brcolor(set_color normal)
    end
  end
end
