# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1="${LTRED}\u${WHITE}@${RED}\h${RESET}:${AMBER}\w${RESET}\$ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# --- Ember Prompt ---
ORANGE='\[\e[38;2;255;140;66m\]'
LTRED='\[\e[38;2;255;107;94m\]'
WHITE='\[\e[38;2;255;255;255m\]'
RED='\[\e[38;2;224;72;61m\]'
AMBER='\[\e[38;2;255;201;107m\]'
RESET='\[\e[0m\]'

PS1="${ORANGE}\u${WHITE}@${RED}\h${RESET}:${AMBER}\w${RESET}\$ "

# --- fastfetch beim Start ---
if [[ $- == *i* ]] && [[ -z "$NO_FASTFETCH" ]]; then
    fastfetch
fi

# --- Ember Prompt: Benutzername in hellerem Rot ---
LTRED='\[\e[38;2;255;107;94m\]'
PS1="${LTRED}\u${WHITE}@${RED}\h${RESET}:${AMBER}\w${RESET}\$ "

# --- Fenstertitel: "Terminal", ausser WIN_TITLE ist gesetzt ---
if [[ $- == *i* ]]; then
    PROMPT_COMMAND='printf "\033]0;%s\007" "${WIN_TITLE:-Terminal}"'
fi

# --- Ember: ls-Farben ---
if [ -r ~/.dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
fi
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -alh --color=auto --group-directories-first'
alias grep='grep --color=auto'
export GREP_COLORS='mt=01;38;2;255;107;94:fn=38;2;161;28;18:ln=38;2;255;140;66'
export PATH="$HOME/.local/bin:$PATH"
alias matrix='unimatrix -c magenta -o -s 95'
alias i3c='nano ~/.config/i3/config'

# --- Ember: Prompt aus der aktiven Palette ---
if [ -f "$HOME/.config/ember/current.conf" ]; then
    . "$HOME/.config/ember/current.conf"
    _h2a() { printf '38;2;%d;%d;%d' 0x${1:1:2} 0x${1:3:2} 0x${1:5:2}; }
    _U="\[\e[$(_h2a ${C_ACC:-#FF6B5E})m\]"
    _W="\[\e[38;2;255;255;255m\]"
    _H="\[\e[$(_h2a ${C_ACC2:-#E0483D})m\]"
    _P="\[\e[$(_h2a ${C_ACC3:-#A11C12})m\]"
    _R="\[\e[0m\]"
    PS1="${_U}\u${_W}@${_H}\h${_R}:${_P}\w${_R}\$ "
fi
