# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# two finger middle click
synclient TapButton3=3 TapButton2=2
set -o vi

# autocomplete case insensitive
bind 'set completion-ignore-case on'

# usage, `up 4` to `cd ..` 4 times
function up {
  ups=""
  for i in $(seq 1 $1)
  do
          ups=$ups"../"
  done
  cd $ups
}

# custom tab completions
if type complete >/dev/null 2>&1
then
    if complete -o >/dev/null 2>&1
    then
        COMPDEF="-o complete"
    else
        COMPDEF="-o default"
    fi
    complete -a alias unalias
    complete -d cd pushd popd pd po
    complete $COMPDEF -g chgrp 2>/dev/null
    complete $COMPDEF -u chown
    complete -j fg
    complete -j kill
    complete $COMPDEF -c command
    complete $COMPDEF -c exec
    complete $COMPDEF -c man
    complete -e printenv
    complete -G "*.java" javac
    complete -F complete_runner -o nospace -o default nohup 2>/dev/null
    complete -F complete_runner -o nospace -o default sudo 2>/dev/null
    complete -F complete_services service
    # completion function for commands such as sudo that take a
    # command as the first argument but should complete the second
    # argument as if it was the first
    complete_runner()
    {
        # completing the command name
        # $1 = sudo
        # $3 = sudo
        # $2 = partial command (or complete command but no space was typed)
        if test "$1" = "$3"
        then
            set -- `compgen -c "$2"`
        # completing other arguments
        else
            # $1 = sudo
            # $3 = command after sudo (i.e. second word)
            # $2 = arguments to command
            # use the custom completion as printed by complete -p,
            # fall back to filename/bashdefault
            local comps
            comps=`complete -p "$3" 2>/dev/null`
            # "complete -o default -c man" => "-o default -c"
            # "" => "-o bashdefault -f"
            comps=${comps#complete }
            comps=${comps% *}
            comps=${comps:--o bashdefault -f}
            set -- `compgen $comps "$2"`
        fi
        COMPREPLY=("$@")
    }

    # completion function for Red Hat service command
    complete_services()
    {
        OIFS="$IFS"
        IFS='
        '
        local i=0
        for file in $(find /etc/init.d/ -type f -name "$2*" -perm -u+rx)
        do
            file=${file##*/}
            COMPREPLY[$i]=$file
            i=$(($i + 1))
        done
        IFS="$OIFS"
    }
fi

# im super lazy

# i -> awk '{print $i};
a() {
  awk "{print \$$1}"
}
# v -> vim
alias v='vim'
# g -> grep
alias g='grep'

