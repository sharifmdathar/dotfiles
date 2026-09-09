# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

export PATH=$PATH:/home/doormat/.spicetify
alias gs="git status"
alias gc="git commit"
alias ga="git add"
alias gp="git push"
alias gl="git log"
alias l="lazygit"

[ -f "$HOME/.config/opencode/.env" ] && . "$HOME/.config/opencode/.env"

. "$HOME/.local/share/../bin/env"

# 1. Load Flyline (the installer should have added this, but just in case)
if [[ -f "$HOME/.local/lib/libflyline.so" ]]; then
    enable -f "$HOME/.local/lib/libflyline.so" flyline 2>/dev/null
fi

# 2. Mouse mode: "smart" is the sweet spot — auto-disables on scroll,
#    re-enables on keypress or focus. Toggle manually with Escape.
flyline mouse --mode smart 2>/dev/null

# 3. Fuzzy matching: enabled everywhere (files, commands, everything)
flyline suggestions set-fuzzy-mode all 2>/dev/null

# 4. Auto-completion synthesis: if a command has no completion script,
#    Flyline will generate one by parsing --help and man pages.
flyline set-setting auto-completion-synthesis true 2>/dev/null

# 5. Auto-closing brackets and quotes — saves keystrokes
flyline set-setting auto-closing-char true 2>/dev/null

# 6. Cursor style: smooth interpolation for a polished feel
flyline set-cursor --interpolate-easing true 2>/dev/null

# 7. Optional: disable inline history if you prefer the popup style
# flyline editor --show-inline-history false

# 8. Rich prompt with right-side status (optional — customize to taste)
PS1="\u@\h:\w\$ "
RPS1="\t"
#PS1_FILL='-'

enable -f /usr/lib/bash/libflyline.so flyline
