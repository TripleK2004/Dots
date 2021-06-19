/usr/bin/colorscript random
##########################   ALIASES   ################################

function ll
	command exa -lah $argv
end
function bat
	command batcat $argv
end
function vim
    command nvim $argv
end
function clear
	command /usr/bin/colorscript -e elfman
end

#set -x MANPAGER "sh -c 'col -bx | bat -l man -p'" 
 set -x MANPAGER "nvim -c 'set ft=man' -"


### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
set fish_color_normal '#8be9fd'
set fish_color_command '#8be9fd'
set fish_color_quote '#f1fa8c'
set fish_color_redirections '#ffb86c'
set fish_color_end '#ff79c6'
set fish_color_error '#ff5555'
set fish_color_param '#50fa7b'
set fish_color_fish_color_comment '#ff79c6'
set fish_color_match '#6272a4'
set fish_color_search_match '#f1fa8c'
set fish_color_operator '#50fa7b'
set fish_color_escape '#bd93f9'
set fish_color_cwd '#ffb86c'
set fish_pager_color_prefix '#8be9fd'
set fish_pager_color_completion '#50fa7b'
set fish_pager_color_description '#bd93f9'
set fish_pager_color_progress '#ffb86c'
set fish_color_autosuggestion '#6272a4'

set fish_greeting
fish_vi_key_bindings

/usr/local/bin/starship init fish | source
