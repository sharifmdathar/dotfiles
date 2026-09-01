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
alias n="nvim"
alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias c="opencode"

# env
set RUSTC_WRAPPER sccache

# pnpm
set -gx PNPM_HOME "/home/ball/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end

mise activate fish | source   
