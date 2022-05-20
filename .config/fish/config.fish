if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g theme_display_user yes
set -g theme_color_scheme nord

neofetch

fish_vi_key_bindings

# vi keybinds for dvorak
bind -m default d backward-char
bind -m default h down-line
bind -m default t up-line
bind -m default n forward-char

bind -m default k kill-whole-line

# Set the cursor shapes for the different vi modes.
set fish_cursor_default     block
set fish_cursor_insert      line
set fish_cursor_replace_one underscore
set fish_cursor_visual      block

alias ls='colorls -lAh'
alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
