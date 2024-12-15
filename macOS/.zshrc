# ~/.zshrc
#
# Author: Sebastian M.
# Email: tuqs@core.ws
#
# 2009-11-15 edited by harlekin
# 2008-03-29 complete rewrite
# 2008-07-04 adding some features
# 2008-10-08 style rewrite

#general transparency for xterm
[ -n "$XTERM_VERSION" ] && transset -a --id "$WINDOWID" >/dev/null

#weechat home dir
export WEECHAT_HOME=/Users/andreas/.weechat/

# vim: set foldmethod=marker :

# disable core dumps
limit coredumpsize 0

# some settings
bindkey -e
READNULLCMD=cat

# path addition
[[ -n "${PATH/*$HOME\/bin:*}" ]] && export PATH="${PATH}:${HOME}/bin"

[[ -d $HOME/tmp ]] && export TMPDIR=$HOME/tmp

export COLORTERM="yes"

# {{{ some favorites
export EDITOR=/usr/local/bin/vim
export PAGER=/usr/bin/less
export SED=/usr/bin/sed
# }}}

# {{{ locales
#export LANG="en_US.utf8"
#export LC_ALL="en_US.utf8"
#export GDM_LANG="en_US.utf8"
#export LESSCHARSET="utf-8"
# }}}

# {{{ colors
local BLACK="%{"$'\033[01;30m'"%}"
local GREEN="%{"$'\033[01;32m'"%}"
local RED="%{"$'\033[01;31m'"%}"
local YELLOW="%{"$'\033[01;33m'"%}"
#local BLUE="%{"$'\033[01;34m'"%}"
local BLUE="%{"$'\033[01;94m'"%}"
local CYAN="%{"$'\033[01;36m'"%}"
local BOLD="%{"$'\033[01;39m'"%}"
local NONE="%{"$'\033[00m'"%}"

#colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
# }}}

#Prompts

# >> ~ % Blaue Pfeile
#export PS1="${BLUE}>> ${GREEN}%~ ${NONE}%# "

#andreas@ABGESCHMIERT ~ % rot@blau
#export PS1="${RED}%n${NONE}@${BLUE}%m ${CYAN}%~ ${NONE}%% "

#>> ~ % Rote Pfeile 
#export PS1="${RED}>> ${BLUE}%~ ${NONE}%# "


#andreas@ABGESCHMIERT ~ % blau@gruen
export PS1="${BLUE}%n${NONE}@${GREEN}%m ${CYAN}%~ ${NONE}%% "



# {{{ timeout
export TMOUT=1200
[[ $TERM = (*term|rxvt*|screen*) ]] && unset TMOUT
# }}}

# {{{ prompt
# tuqs@FUCKUP ~ %
#export PS1="${BLUE}%n${NONE}@${GREEN}%m ${CYAN}%~ ${NONE}%% "

# >> ~ %
# export PS1="${BLUE}>> ${GREEN}%~ ${NONE}# "
#
# root prompt
 [[ $UID = 0 ]] && export PS1="${RED}>> ${BLUE}%~ ${NONE}%# "
 [[ $UID = 0 ]] && export PS1="${RED}%n${NONE}@${BLUE}%m ${CYAN}%~ ${NONE}%% "
#
# clock
export RPROMPT="${BLUE}%T${NONE}"
# }}}

# {{{ root su hack
[[ $(dirname $PWD) = "/home" ]] && cd
# }}}

# {{{ term title
if [[ $TERM = *term || $TERM = rxvt* || $TERM = screen ]]; then
      precmd()  { print -Pn "\e]0;%n@%m - %~\a" }
      preexec() { print -Pn "\e]0;%n@%m - $1\a" }
fi
# }}}

# {{{ dir colors
#if [[ -f ~/.dir_colors ]]; then
#   eval `dircolors -b ~/.dir_colors`
#elif [[ -f /etc/DIR_COLORS ]]; then
#   eval `dircolors -b /etc/DIR_COLORS`
#else
#   eval `dircolors -b`
#fi
export ZLSCOLORS="${LS_COLORS}"
# }}}

# {{{ functions
alias calc="noglob _calc"
_calc() { awk "BEGIN { print $* }" }

mkcd() { mkdir -p "$@"; cd "$@" }
tcp() { tar -c $1 | tar -C $2 -xv }

digest() { ebuild ${$(command ls *.ebuild )[#-1]} digest }

2html() { vim -n -c ':so $VIMRUNTIME/syntax/2html.vim' -c ':wqa' $1 > /dev/null 2> /dev/null }

unkey_host() {
   if [[ ! $# -eq 1 ]]; then
      echo "usage: unkey_host <hostname>"
   else
      sed -i -e "/$1/d" $HOME/.ssh/known_hosts
   fi
}

# }}}

# {{{ bindkeys
bindkey '\e[3~' delete-char
bindkey '\e[5~' up-history
bindkey '\e[6~' down-history
if [[ $TERM == rxvt* ]]; then
   bindkey '\e[7~' beginning-of-line
   bindkey '\e[8~' end-of-line
elif [[ $TERM == "linux" ]]; then
   bindkey '\e[1~' beginning-of-line
   bindkey '\e[4~' end-of-line
elif [[ $TERM == "screen" ]]; then
   bindkey "^[[1~" beginning-of-line
   bindkey "^[[4~" end-of-line
else
   bindkey '\e[H~' beginning-of-line
   bindkey '\e[F~' end-of-line
fi
# }}}

# {{{ history
setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY
setopt BANG_HIST
setopt HIST_REDUCE_BLANKS HIST_IGNORE_DUPS HIST_IGNORE_SPACE
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
DIRSTACKSIZE=20
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "\e[A"  history-beginning-search-backward-end
bindkey "\e[B"  history-beginning-search-forward-end
# }}}

# {{{ aliases
alias rehash='source ~/.zshrc'
# global
alias -g G='|grep'
alias -g L='|wc -l'
alias -g H='|head'
alias -g T='|tail'
alias -g S='|sort'
alias -g N='&>/dev/null'

# ls
alias ls='ls -h --color=always'
alias ll='ls -l' 
alias la='ls -A'
alias lla='ls -lA'

#
alias grep='grep --color=auto'
alias cd..='cd ..'
alias ...='cd ../..'
alias ..='cd ..'
alias df='df -h'
alias cl='clear'
alias cp='nocorrect cp'
alias mv='nocorrect mv'
alias rm='nocorrect rm'
alias mkdir='nocorrect mkdir -p'
alias mkcd='nocorrect mkcd'
alias su='/bin/su -'
alias cal='cal -m'
alias :q='exit'
alias :x='exit'
#
alias vib='vim ~/.bashrc'
alias viz='vim ~/.zshrc'
alias vixd='vim ~/.Xdefaults'
alias vixi='vim ~/.xinitrc'
alias vipr='vim /etc/profile'

#my own aliases
alias usbon='mount /mnt/usbstick'
alias usboff='cd ~/ && umount /mnt/usbstick'
alias dropbox='python2 ~/dropbox.py puburl'
#shutdown aliases
alias reboot='doas reboot'
alias halt='doas halt'
alias poweroff='doas poweroff'

# {{{ options
setopt AUTO_CD # implicate cd for non-commands
setopt AUTO_LIST # automatically list choices on an ambiguous completion
setopt AUTO_PUSHD # push dirs into history
setopt AUTO_MENU # use menu completion
setopt AUTO_PARAM_SLASH # add a slash instead of space if the completed name was a directory
setopt ALWAYS_TO_END # move to the end on complete completion
setopt C_BASES # 0xFF
setopt CD_ABLE_VARS # read vars in cd
setopt CORRECT # correct spelling
setopt CHASE_LINKS # follow links in cds
setopt COMPLETE_IN_WORD # complete commands anywhere in the word
setopt EXTENDED_GLOB # extended globbing
setopt LIST_PACKED # make the completion list smaller
setopt LIST_ROWS_FIRST # row orientation for menu
setopt LONG_LIST_JOBS # list jobs in the long format
setopt MULTIOS # allow multiple pipes
setopt NOTIFY # notify when jobs finish
setopt NOCDABLEVARS # no need
setopt NONOMATCH #avoid zsh: no matches ...
setopt GLOB # perform filename generation (globbing)
setopt PUSHD_SILENT # do not print the directory stack after pushd
setopt PUSHD_TO_HOME # pushd with no arguments is like pushd $HOME
setopt PUSHD_IGNORE_DUPS # ignore multiple copies of the same directory
setopt LOGIN # this is a login shell
setopt TRANSIENT_RPROMPT # rprompt copy pasta fix
unsetopt BEEP # do not beep
unsetopt BG_NICE # no renice for processes at background
# }}}

# {{{ modules
autoload -Uz compinit; compinit -d ~/.zsh_compdump
autoload -U url-quote-magic; zle -N self-insert url-quote-magic
# }}}

# {{{ completention
compctl -g '*.ebuild' ebuild
compctl -g '*(-/)' + -g '.*(-/)' -v cd pushd
compctl -g '*.(e|)ps' + -g '*(-/)' gs ghostview
compctl -g '*.mp3 *.ogg *.wav *.avi *.mpg *.mpeg *.wmv' + -g '*(-/)' mplayer
compctl -g '*.(jpg|JPG|jpeg|JPEG|gif|GIF|png|PNG|bmp)' + -g '*(-/)' feh
compctl -k hosts ssh scp
# }}}

# {{{ zstyle
# menu
zstyle ':completion:*' menu select=1
# use cache
zstyle ':completion:*' use-cache on
# completion colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# kill menu
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
# kill menu extension
[[ $UID = 0 ]] &&
  zstyle ':completion:*:processes' command 'ps axf -o pid,%cpu,%mem,tty,cputime,cmd | sed /ps/d' ||
  zstyle ':completion:*:processes' command 'ps f -u $USER -o pid,%cpu,%mem,tty,cputime,cmd | sed /ps/d'
zstyle ':completion:*:processes' insert-ids menu yes select
# kill menu colors
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# menu for directroy stack
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
# prevent re-suggestion
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:scp:*' ignore-line yes
zstyle ':completion:*:ls:*' ignore-line yes
# path expansion
# zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'
# misc
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format 'Sorry, no matches for: %d'
# }}}

# {{{ scp
cp2c()    { scp $* c: }
cp2web()  { scp $* c:public_html/pub/ }
cp2pub()  { scp $* c:public_html/pub/ }
cp2priv() { scp $* c:public_html/priv/ }
cp2dev()  { scp $* c:public_html/pub/dev/ }
cp2img()  { scp $* c:public_html/pub/img/ }
cp2conf() { scp $* c:public_html/pub/conf/ }
# }}}


is4(){
[[ $ZSH_VERSION == <4->* ]] && return 0
return 1
}

# TO BE TESTED
if is4 && [[ -n ${(k)modules[zsh/complist]} ]] ; then
	#k# menu selection: pick item but stay in the menu
	bindkey -M menuselect '\e^M' accept-and-menu-complete
	# also use + and INSERT since it's easier to press repeatedly
	bindkey -M menuselect "+" accept-and-menu-complete
	bindkey -M menuselect "^[[2~" accept-and-menu-complete

	# accept a completion and try to complete again by using menu
	# completion; very useful with completing directories
	# by using 'undo' one's got a simple file browser
	bindkey -M menuselect '^o' accept-and-infer-next-history
fi

# completion system

# called later (via is4 && grmlcomp)
# note: use 'zstyle' for getting current settings
#         press ^xh (control-x h) for getting tags in context; ^x? (control-x ?)      to run complete_debug with trace output
grmlcomp() {
# TODO: This could use some additional information

# allow one error for every three characters typed in approximate completer
zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUF     FIX)/3 )) numeric )'

# don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '(aptitu     de-*|*\~)'

# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'       insert-unambiguous true
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{     \e[0m%}'
zstyle ':completion:*:correct:*'       original true

# activate color-completion
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

# format on completion
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b     %{\e[0m%}'

# automatically complete 'cd -<tab>' and 'cd -<ctrl-d>' with menu
# zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# insert all expansions for expand completer
zstyle ':completion:*:expand:*'        tag-order all-expansions
zstyle ':completion:*:history-words'   list false

# activate menu
zstyle ':completion:*:history-words'   menu yes

# ignore duplicate entries
zstyle ':completion:*:history-words'   remove-all-dups yes
zstyle ':completion:*:history-words'   stop yes

# match uppercase from lowercase
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'

# separate matches into groups
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''

if [[ "$NOMENU" -eq 0 ]] ; then
# if there are more than 5 options allow selecting from a menu
zstyle ':completion:*'               menu select=5
else
# don't use any menus at all
setopt no_auto_menu
fi

zstyle ':completion:*:messages'        format '%d'
zstyle ':completion:*:options'         auto-description '%d'

# describe options in full
zstyle ':completion:*:options'         description 'yes'

# on processes completion complete all user processes
zstyle ':completion:*:processes'       command 'ps -au$USER'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# provide verbose completion information
zstyle ':completion:*'                 verbose true

# recent (as of Dec 2007) zsh versions are able to provide descriptions
# for commands (read: 1st word in the line) that it will list for the user
# to choose from. The following disables that, because it's not exactly fast.
zstyle ':completion:*:-command-:*:'    verbose false

# set format for warnings
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{     \e[0m%} %d'

# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
zstyle ':completion:correct:'          prompt 'correct to: %e'

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command |      uniq'

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

# Search path for sudo completion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
/usr/local/bin  \
/usr/sbin       \
/usr/bin        \
/sbin           \
/bin            \
/usr/X11R6/bin


# run rehash on completion so new installed program are found automatically:
_force_rehash() {
(( CURRENT == 1 )) && rehash
return 1
}

## correction
# some people don't like the automatic correction - so run 'NOCOR=1 zsh' to d     eactivate it
if [[ "$NOCOR" -gt 0 ]] ; then
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete      _files _ignored
setopt nocorrect
else
# try to be smart about when to use what completer...
setopt correct
zstyle -e ':completion:*' completer '
if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]] ; then
_last_try="$HISTNO$BUFFER$CURSOR"
reply=(_complete _match _ignored _prefix _files)
else
if [[ $words[1] == (rm|mv) ]] ; then
reply=(_complete _files)
else
reply=(_oldlist _expand _force_rehash _complete _ignored _cor     rect _approximate _files)
fi
fi'
fi

# command for process lists, the local web server details and host completion
zstyle ':completion:*:urls' local 'www' '/var/www/' 'public_html'

# caching
[[ -d $ZSHDIR/cache ]] && zstyle ':completion:*' use-cache yes && \
zstyle ':completion::complete:*' cache-path $ZSHDIR/c     ache/

# host completion
if is42 ; then
[[ -r ~/.ssh/known_hosts ]] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/know     n_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[[ -r /etc/hosts ]] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(<     /etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
else
_ssh_hosts=()
_etc_hosts=()
fi
hosts=(
$(hostname)
"$_ssh_hosts[@]"
"$_etc_hosts[@]"
grml.org
localhost
)
zstyle ':completion:*:hosts' hosts $hosts
# TODO: so, why is this here?
#  zstyle '*' hosts $hosts

# use generic completion system for programs not yet defined; (_gnu_generic w     orks
# with commands that provide a --help option with "standard" gnu-like output.     )
for compcom in cp deborphan df feh fetchipac head hnb ipacsum mv \
pal stow tail uname ; do
[[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
done; unset compcom

# see upgrade function in this file
compdef _hosts upgrade
}
