export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

set -U fish_greeting

export NC=$HOME/.config/nvim/

if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias ls="exa --all --long --icons --group-directories-first"
alias ll="exa --long --icons"

starship init fish | source
