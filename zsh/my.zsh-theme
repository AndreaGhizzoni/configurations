# My zhs theme based on gallifrey.zsh-theme
#
# put this file in ~/.oh-my-zsh/custom/thems

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

# %m display the host name
# %2~ display the current working directory
PROMPT='%{$fg[blue]%}%m%{$reset_color%} %2~ $(git_prompt_info)%{$reset_color%}%B»%b '
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}@ "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}[!]"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}? "
