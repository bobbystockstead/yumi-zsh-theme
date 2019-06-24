# kphoen.zsh-theme

if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
    PROMPT='[%{$fg[magenta]%}%n%{$reset_color%}:%{$fg[blue]%}%3~%{$reset_color%}$(git_prompt_info)]  $(printDashes)
%# '
    ## {1..'"${COLUMNS:-$(tput cols)}"
    ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[green]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    # display exitcode on the right when >0
    return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

    RPROMPT='${return_code}$(git_prompt_status)%{$reset_color%}'

    ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚✚"
    ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹✹"
    ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖✖"
    ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ══"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%} ✭✭"
else
    PROMPT='[%n@%m:%~$(git_prompt_info)]
%# '

    ZSH_THEME_GIT_PROMPT_PREFIX=" on"
    ZSH_THEME_GIT_PROMPT_SUFFIX=""
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    # display exitcode on the right when >0
    return_code="%(?..%? ↵)"

    RPROMPT='${return_code}$(git_prompt_status)'

    ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
    ZSH_THEME_GIT_PROMPT_MODIFIED=" ✹"
    ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
    ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
    ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✭"
fi

function printDashes() {
    # length of '[z002mrf:]  '
    userPromptLength=12
    # length of ' on %{$fg[g]%}{$r%}'
    gitExtraLength=19

    # Calculate path length
    if [ `pwd` = '/Users/z002mrf' ]; then
        shortPath='~'
    else 
        shortPath=`pwd | gawk -F/ '{print $(NF-2)"/"$(NF-1)"/"$NF}' | sed -e "s/Users\/z002mrf/~/g" | sed -e "s/z002mrf/~/g"`
    fi

    pathLength=`echo $shortPath | wc -m | tr -d ' '`
    promptLength="$(($userPromptLength+$pathLength))"
    
    # Caclulate git length
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        gitLength=`git_prompt_info | wc -m | tr -d ' '`
        gitLength=$(($gitLength-$gitExtraLength))
    else 
        gitLength='0'
    fi            

    # Calculate offset
    offset="$(($promptLength+$gitLength))"

    # print the dashes
    eval printf %.0s- '{'"$offset"'..'"${COLUMNS:-$(tput cols)}"\}
    echo
}