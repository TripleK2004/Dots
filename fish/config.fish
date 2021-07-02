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
function neovide
	command neovide > /dev/null 2>&1 $argv
end

#set -x MANPAGER "sh -c 'col -bx | bat -l man -p'" 
set -x MANPAGER "nvim -c 'set ft=man' -"
set PATH $PATH /home/triplek/.local/bin /usr/bin /usr/local/bin /usr/sbin /usr/local/sbin /bin /sbin $HOME/.fzf/bin $HOME/.cargo/bin $HOME/.config/scripts $HOME/spicetify-cli

set fish_greeting
fish_vi_key_bindings

/usr/local/bin/starship init fish | source
