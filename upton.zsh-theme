# https://github.com/haesken
#
# Modified from the Blinks theme, with some code from Steve Losh's site.
# https://github.com/blinks zsh theme
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

function prompt_char {
    git rev-parse --is-inside-work-tree > /dev/null 2>&1 && echo '±' || echo '○'
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{%F{cyan}%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$reset_color%}%{%B%F{red}%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""


# %                - the escape character
# %{%f%k%b%}       - resets coloring/bolding
# %{$reset_color%} - resets coloring/bolding
# %{%F{COLOR}%}    - sets a color
# %{%B%F{COLOR}%}  - sets a bold color (solarized uses some of these for grays)

# %n               - user
# @                - literal @
# %m               - short hostname
# %~               - path (truncated when in home dir)
# git_prompt_info  - branch/status of the current git repo
# hg_prompt_info   - branch/status of the current mercurial repo
# prompt_char      - if you are in a git/hg repo
# %E               - clear till end of line
# %#               - % if user, # if root

function user_name {
	[[ "$SSH_CONNECTION" != '' ]] && echo '%{%F{yellow}%}%n%{%F{gray}%}@%{%F{blue}%}%m ' && return
    echo ''
}

PROMPT='%{%F{cyan}%}$(prompt_char)%{$reset_color%} \
$(user_name)%{$reset_color%}\
%{%B%F{green}%}${PWD/#$HOME/~}%{$reset_color%} \
$(git_prompt_info)%{$reset_color%}%E
%(?.%F{blue}.%F{red})❯%{$reset_color%} '

#RPROMPT='%{%F{gray}%}!%h%{$reset_color%} %{%F{yellow}%}%T%{$reset_color%}'
