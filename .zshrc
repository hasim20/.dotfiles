# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/hasim/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

export ZSH_THEME="minimal"
export EDITOR="nvim"
export PATH="$PATH:$HOME/.local/bin:$HOME/development/flutter/bin"

# Prompt
PROMPT="%F{green}λ%F %F{white}%~%f "

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)






# Aliases
alias ls='ls -la -p -h --color=auto --group-directories-first'
alias e='yazi'

# cd with fzf
alias cdf='cd "./$(find -type d | fzf)"'


source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
