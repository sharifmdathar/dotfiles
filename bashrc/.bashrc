#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

. "$HOME/.cargo/env"
alias ls='ls --color=auto'
alias ll='ls -la'
alias grep='grep --color=auto'
alias ip="ip --color=auto"
alias gst="git status"
alias gc="git commit -sam"
alias ga="git add"
alias gp="git push"

PS1='\[\e[36m\]\W \[\e[33m\]\$ \[\e[0m\]'
export LC_ALL="en_US.UTF-8"
