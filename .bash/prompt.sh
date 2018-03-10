### COLOR DEFINITIONS
# Define foreground colors
readonly _FG_BLACK="\[\033[0;30m\]"
readonly _FG_BLUE="\[\033[0;34m\]"
readonly _FG_BLUE_LT="\[\033[1;34m\]"
readonly _FG_BROWN="\[\033[0;33m\]"
readonly _FG_CYAN="\[\033[0;36m\]"
readonly _FG_CYAN_LT="\[\033[1;36m\]"
readonly _FG_GRAY="\[\033[1;30m\]"
readonly _FG_GRAY_LT="\[\033[0;37m\]"
readonly _FG_GREEN="\[\033[0;32m\]"
readonly _FG_GREEN_LT="\[\033[1;32m\]"
readonly _FG_PURPLE="\[\033[0;35m\]"
readonly _FG_PURPLE_LT="\[\033[1;35m\]"
readonly _FG_RED="\[\033[0;31m\]"
readonly _FG_RED_LT="\[\033[1;31m\]"
readonly _FG_WHITE="\[\033[1;37m\]"
readonly _FG_YELLOW="\[\033[1;33m\]"
# Define background colors
readonly _BG_BLACK="\[\033[0;40m\]"
readonly _BG_BLUE="\[\033[0;44m\]"
readonly _BG_BLUE_LT="\[\033[1;44m\]"
readonly _BG_BROWN="\[\033[0;43m\]"
readonly _BG_CYAN="\[\033[0;46m\]"
readonly _BG_CYAN_LT="\[\033[1;46m\]"
readonly _BG_GRAY="\[\033[1;40m\]"
readonly _BG_GRAY_LT="\[\033[0;47m\]"
readonly _BG_GREEN="\[\033[0;42m\]"
readonly _BG_GREEN_LT="\[\033[1;42m\]"
readonly _BG_PURPLE="\[\033[0;45m\]"
readonly _BG_PURPLE_LT="\[\033[1;45m\]"
readonly _BG_RED="\[\033[0;41m\]"
readonly _BG_RED_LT="\[\033[1;41m\]"
readonly _BG_WHITE="\[\033[1;47m\]"
readonly _BG_YELLOW="\[\033[1;43m\]"

# git status colors


readonly GIT_BRANCH_SYMBOL=' '
readonly GIT_BRANCH_CHANGED_SYMBOL='(*) '
readonly GIT_NEED_PUSH_SYMBOL='>> '
readonly GIT_NEED_PULL_SYMBOL='<< '
readonly RESET="\[$(tput sgr0)\]"
readonly BG_BLUE="\[$(tput setab 4)\]"
readonly BG_BASE03="\[$(tput setab 8)\]"




#define color reset
readonly _NO_COLOR="\[\033[0m\]"




# what OS?
case "$(uname)" in
    Darwin)
        readonly _PS_SYMBOL=''
        ;;
    Linux)
        readonly _PS_SYMBOL='§'
        ;;
    *)
        readonly _PS_SYMBOL='$'
esac


# time function
function _time() {
    tput sc
    tput cup 0 $(($(tput cols)-5))
    date +%H:%M
    tput rc
}

git_info() {
        [ -x "$(which git)" ] || return    # git not found

        local git_eng="env LANG=C git"   # force git output in English to make our work easier
        # get current branch name or short SHA1 hash for detached head
        local branch="$($git_eng symbolic-ref --short HEAD 2>/dev/null || $git_eng describe --tags --always 2>/dev/null)"
        [ -n "$branch" ] || return  # git branch not found

        local marks

        # branch is modified?
        [ -n "$($git_eng status --porcelain)" ] && marks+=" $GIT_BRANCH_CHANGED_SYMBOL"

        # how many commits local branch is ahead/behind of remote?
        local stat="$($git_eng status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
        local aheadN="$(echo $stat | grep -o 'ahead [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
        local behindN="$(echo $stat | grep -o 'behind [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
        [ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$aheadN"
        [ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL$behindN"

        # print the git branch segment without a trailing newline
        printf " $GIT_BRANCH_SYMBOL$branch$marks "
    }

# PS1 Calc function
function ps1() {
    # last exit bg color
    if [ $? -eq 0 ]; then
        local BG_EXIT="$_BG_GREEN"
        local FG_EXIT="$_FG_GREEN"
    else
        local BG_EXIT="$_BG_RED"
        local FG_EXIT="$_FG_RED"
    fi

    # print time if we can
    # if hash tput 2>/dev/null; then
    #     printf "$(_time)"
    # fi

    # set PS1
    PS1="${_BG_GRAY_LT}${_FG_GRAY} $(hostname) "
    PS1+="${_FG_GRAY_LT}${_BG_CYAN_LT}${_FG_WHITE} \W "
    PS1+="${_BG_BLUE_LT}$(git_info)${_FG_WHITE}"
    PS1+="${_FG_CYAN}${BG_EXIT}${_FG_WHITE} $_PS_SYMBOL "
    PS1+="${_NO_COLOR}${FG_EXIT}${_NO_COLOR} "


}
# Directory Colors
# LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
# export LS_COLORS


# Run function for each prompt
PROMPT_COMMAND=ps1
