export GALLIUM_DRIVER=d3d12
export LIBVA_DRIVER_NAME=d3d12

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

alias ls=eza
alias cd=z
alias du=dust
alias find=fd
alias cat=bat
alias less=most
alias nano=nvim
alias vi=nvim
alias vim=nvim
alias grep=rg
alias python=python3

select-word-style bash
autoload -U colors && colors
autoload -Uz compinit && compinit
autoload -Uz select-word-style
fzf-history-widget() {
    local selected_command
    selected_command=$(fc -l -n -100 | fzf --tac)
    LBUFFER+="$selected_command"
}
bindkey '^R' fzf-history-widget


# ==========================
# Keyboard Shortcuts / Bindings
# ==========================
bindkey -e
bindkey '^[[H' beginning-of-line         # Home
bindkey '^[[F' end-of-line               # End
bindkey '^[[3~' delete-char              # Delete
bindkey '^?' backward-delete-char        # Backspace

bindkey '^[[1;5C' forward-word           # Ctrl + Right
bindkey '^[[1;5D' backward-word          # Ctrl + Left

bindkey '^H' backward-kill-word          # Ctrl + Backspace (sometimes ^W works better)
bindkey '^[[3;5~' kill-word              # Ctrl + Delete

bindkey '^E' end-of-line                 # Ctrl + E → End of line
bindkey '^K' kill-line                   # Ctrl + K → Delete to end of line
bindkey '^U' backward-kill-line          # Ctrl + U → Delete whole line
bindkey '^Y' yank                        # Ctrl + Y → Paste last killed text

alias ip='ip --color=auto'

export EDITOR="nvim"
export VISUAL="nvim"

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
setopt AUTO_CD
setopt CORRECT
setopt NO_BEEP

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
