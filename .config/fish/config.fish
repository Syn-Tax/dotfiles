function sudo --description "Replacement for Bash 'sudo !!' command to run last command using sudo."
    if test "$argv" = !!
    eval command sudo $history[1]
else
    command sudo $argv
    end
end

alias config="/usr/bin/git --git-dir=/home/oscar/dotfiles/ --work-tree=/home/oscar/"
alias ls="ls -lAh"
alias "wtf"="sshfs pi@192.168.1.124:/home/pi /home/oscar/WTF -C"

abbr p "sudo pacmman"
abbr pi "sudo pacman -S"
abbr pu "sudo pacman -Syu"
abbr SS "sudo systemctl"
abbr pipu "sudo pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"

set PATH /home/oscar/.local/bin $PATH
set PATH /home/oscar/.emacs.d/bin $PATH
set PATH /home/oscar/scripts $PATH
set PATH /home/oscar/blender-git/build_linux/bin/blender $PATH

