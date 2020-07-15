neofetch

function sudo --description "Replacement for Bash 'sudo !!' command to run last command using sudo."
    if test "$argv" = !!
    eval command sudo $history[1]
else
    command sudo $argv
    end
end

alias config="/usr/bin/git --git-dir=/home/oscar/dotfiles/ --work-tree=/home/oscar/"
alias ls="ls -lah"

abbr p "sudo pacmman"
abbr pi "sudo pacman -S"
abbr pu "sudo pacman -Syu"
abbr SS "sudo systemctl"
