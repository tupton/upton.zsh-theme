# https://github.com/haesken
#
# Modified from the Blinks theme, with some code from Steve Losh's site.
# https://github.com/blinks zsh theme
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

function prompt_char {
    git rev-parse --is-inside-work-tree > /dev/null 2>&1 && echo '±' || echo '○'
}

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

setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:git*' stagedstr '+'
zstyle ':vcs_info:git*' unstagedstr '*'
zstyle ':vcs_info:git*' actionformats "%b|%a "
zstyle ':vcs_info:git*' formats "%b %c%u%m "
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' enable git

+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' && \
            $(git ls-files --other --directory --exclude-standard | sed q | wc -l | tr -d ' ') == 1 ]]; then
        hook_com[unstaged]+='?'
    fi
}

precmd() { vcs_info }

PROMPT='%{%F{cyan}%}$(prompt_char)%{$reset_color%} \
$(user_name)%{$reset_color%}\
%{%B%F{green}%}${PWD/#$HOME/~}%{$reset_color%} \
${vcs_info_msg_0_}%{$reset_color%}%E
%(?.%F{blue}.%F{red})❯%{$reset_color%} '

#RPROMPT='%{%F{gray}%}!%h%{$reset_color%} %{%F{yellow}%}%T%{$reset_color%}'
