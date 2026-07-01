source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
#    # smth smth
end

# paths
fish_add_path ~/.spicetify
fish_add_path ~/.bun/bin
fish_add_path ~/.cargo/bin/

zoxide init fish | source

# aliases
alias cd=z
alias n=nvim
