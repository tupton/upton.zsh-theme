# https://github.com/haesken
#
# Modified from the Blinks theme, with some code from Steve Losh's site.
# https://github.com/blinks zsh theme
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

function prompt_char() {
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

function user_name() {
	[[ "$SSH_CONNECTION" != '' ]] && echo '%{%F{yellow}%}%n%{%F{gray}%}@%{%F{blue}%}%m ' || echo ''
}

setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:git*' stagedstr '%F{green}+%f'
zstyle ':vcs_info:git*' unstagedstr '%F{red}*%f'
zstyle ':vcs_info:git*' actionformats '%F{cyan}%b%f|%F{yellow}%a%f '
zstyle ':vcs_info:git*' formats '%F{cyan}%b%f %c%u%m '
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-aheadbehind git-tagname
zstyle ':vcs_info:*' enable git

function +vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' && \
            $(git ls-files --others --directory --exclude-standard | sed q | wc -l | tr -d ' ') != 0 ]]; then
        hook_com[unstaged]+='%{%F{yellow}%}?%{%f%}'
    fi
}

function +vi-git-aheadbehind() {
    local ahead behind
    local -a gitstatus

    # for git prior to 1.7
    # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l | tr -d ' ')
    (( $ahead )) && gitstatus+=( "%B%F{magenta}↑${ahead}%f%b" )

    # for git prior to 1.7
    # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l | tr -d ' ')
    (( $behind )) && gitstatus+=( "%F{magenta}↓${behind}%f" )

    hook_com[misc]+=${(j::)gitstatus}
}

function +vi-git-tagname() {
    local tag

    tag=$(git describe --tags --contains --exact-match HEAD 2>/dev/null)
    [[ -n "$tag" ]] && hook_com[branch]=${tag}
}

precmd() { vcs_info }

PROMPT='%{%F{cyan}%}$(prompt_char)%{$reset_color%} \
$(user_name)%{$reset_color%}\
%{%B%F{green}%}${PWD/#$HOME/~}%{$reset_color%} \
${vcs_info_msg_0_}%{$reset_color%}%E
%(?.%F{blue}.%F{red})❯%{$reset_color%} '

#RPROMPT='%{%F{gray}%}!%h%{$reset_color%} %{%F{yellow}%}%T%{$reset_color%}'
