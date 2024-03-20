setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

function gs {
    if  git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    untracked_count=$(git status --porcelain 2>/dev/null | grep "^??" | wc -l)
    modified_count=$(git status --porcelain 2>/dev/null | grep "^ M" | wc -l)
    echo "$untracked_count|$modified_count "
fi }



PROMPT=$'%F{%(#.blue.green)}${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}[%B%F{reset}$([ -z $SSH_TTY ] || echo "$USER@$HOST ")%F{red}$(gs)%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
# Right-side prompt with exit codes and background processes
RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'

VIRTUAL_ENV_DISABLE_PROMPT=1





# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias diff='diff --color=auto'
    alias ip='ip --color=auto'
    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi




# some more ls aliases
type exa  > /dev/null && alias ls=exa && alias ll='exa -la -g' 
type nala > /dev/null && alias apt=nala
type nvim > /dev/null && alias vi=/usr/bin/nvim && EDITOR=nvim


ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)


[ ! -f $HOME/.config/antigen.zsh ] && curl -sL git.io/antigen -o $HOME/.config/antigen.zsh

source $HOME/.config/antigen.zsh
# antigen use oh-my-zsh
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zdharma-continuum/fast-syntax-highlighting
#antigen bundle jeffreytse/zsh-vi-mode
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle command-not-found
antigen apply

bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action


bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down


internal='10.0.0.0/8 172.16.0.0/12 192.168.0.0/16'

function history_log {

        export HISTTIMEFORMAT="%F-%T-%Z "
        if [ ! -d "~/.logs/terminal_log" ]; then
                mkdir -p ~/.logs/terminal_log
        fi
        test "$(ps -ocommand= -p $PPID | awk '{print $1}')" == 'script' || (script -f ~/.logs/terminal_log/$(date "+%Z-%d-%m_%Y_%H-%M-%S")_"$$"_shell.log)
}


eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '
export COMMAND_NOT_FOUND_INSTALL_PROMPT=1
export T_REPOS_DIR="/opt"
export PATH="$TMUX_PLUGIN_MANAGER_PATH/t-smart-tmux-session-manager/bin:$PATH:/opt:$HOME/.local/bin:$HOME/go/bin"

alias history="history 0"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias cat=batcat 
alias hosts="sudo.exe wsl nvim /mnt/c/Windows/System32/drivers/etc/hosts"

export PATH="/opt:$HOME/.local/bin:$HOME/go/bin:$PATH"

[ "$EUID" -eq 0 ] && prompt_symbol=💀

