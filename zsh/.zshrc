

# P10k config =========================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi



# Pyenv =========================================
# Pyenv slows down terminal startup considerably. 
# The init code below is a faster alternative: https://github.com/pyenv/pyenv/issues/2918#issuecomment-1977029534
pyenv() {
    eval "$(command pyenv init -)"
    pyenv "$@"
}



# Conda =========================================
#   Replacing the default init code with $HOME to make this user agnostic
__conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup



# Oh-My-Zsh and P10k =========================================
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
plugins=(git colorize)
ZSH_COLORIZE_STYLE="zenburn"  # Color options: https://pygments.org/styles/
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/powerlevel10k/powerlevel10k.zsh-theme  # Required for manual installation route of P10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



# fzf =========================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--style full --height=50% --preview 'fzf-preview.sh {}' --preview-window=right:60%:wrap"



# zsh-syntax-highlighting =========================================
# Should stay at the end of .zshrc
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh



# Aliases =========================================
alias c="clear"
alias x="exit"
alias cat="ccat"  # Override 'cat' command to use colorize plugin
alias restart='source ~/.zshrc'
alias gs='git status'
alias glo='git log --graph --pretty="format:%C(auto)%h% %C(auto)%d%Creset %s %Cgreen(%ad)   %C(blue bold)<%an> %Creset%C(magenta italic)%ae"'  # Override OMZ "glo" alias to include more info/styling
# NOTE - 'glod' and 'gst' override aliases by the same name from OMZ
alias gst='git stash -u'  # Stash untracked files by default as well
alias glod='git log --pretty="format:%C(auto)%h% %C(auto)%d%Creset %s %Cgreen(%ad)   %C(blue bold)<%an> %Creset%C(magenta italic)%ae" -p'  # Same as above, but adding a git diff for each commit
alias gcm='git commit -m'
alias oops='git reset --soft HEAD~1'


# Custom commands =========================================
function align_staging() {  # Auto rebase branch against staging
    BRANCH=$(git branch --show-current)
    git checkout development && git pull && git checkout $BRANCH && git rebase development
}

function align_prod() {  # Auto rebase branch against production
    BRANCH=$(git branch --show-current)
    git checkout master && git pull && git checkout $BRANCH && git rebase master
}

function make_release_branch() {  # Create production release branch
    BRANCH=$(git branch --show-current)
    git checkout master && git pull && git checkout -b release-"$BRANCH"
}

function git_ref() {
    # cat a txt file showing the subset of git aliases from the OMZ
    # git plugins I'm actively using + custom git aliases, for quicker reference
    cat "$HOME/.dotfiles/refs/git_alias_reference.txt"
}