# Prompt-setting scripts suitable for both zsh and bash

# Do not execute this script in zsh emulation context
if [ -n "$ZSH_VERSION" ] && [ "$(emulate)" != "zsh" ]; then
    return 0
fi

_prompt_sep() {
    printf '%.0s-' $(seq 1 $COLUMNS)
    printf "\n"
}

_prompt_time() {
    printf "%*s" $COLUMNS "($(date +"%F %H:%M"))"
}

_prompt_load() {
    printf "(%s)" "$(awk '{ print $1, $2, $3 }' < /proc/loadavg)"
}

_prompt_mem() {
    printf "(%s)" "$(free | awk '/Mem:/ {printf("%.0f%%", $3/$2*100)}')"
}

_get_prompt() {
    local last_code=$?
    local _reset _dim _bold _set_cur _reset_cur _blue _green _red
    _reset="\[$(tput sgr0)\]"
    _dim="\[$(tput dim)\]"
    _bold="\[$(tput bold)\]"
    _set_cur="\[$(tput sc)"
    _reset_cur="$(tput rc)\]"
    _blue="\[$(tput setaf 4)\]"
    _green="\[$(tput setaf 2)\]"
    _red="\[$(tput setaf 1)\]"
    # Separator
    _prompt_="$_dim(END)\n$(_prompt_sep)$_reset"
    # Status line
    # Time
    _prompt_+="$_set_cur$_blue$(_prompt_time)$_reset$_reset_cur"
    # Last code
    local _shell
    [[ -n $BASH ]] && _shell=bash
    [[ -n $ZSH_NAME ]] && _shell=zsh
    [[ -z $_shell ]] && _shell='?sh'
    local _code_prompt='[$?'" $_shell]"
    if [[ $last_code == 0 ]]; then
        _prompt_+="$_green$_code_prompt $_reset"
    else
        _prompt_+="$_red$_code_prompt $_reset"
    fi
    # Load
    _prompt_+="$_blue$_bold$(_prompt_load)$_reset"
    # Mem
    _prompt_+="$_blue$_bold$(_prompt_mem) $_reset"
    # Extra contexts
    _prompt_+="$_bold$PROMPT_CONTEXT$_reset\n"
    # Context line
    # Root indicator
    local _user_color
    if [[ $UID == 0 ]]; then
        _user_color="$_red"
    else
        _user_color="$_green"
    fi
    # User@Host
    _prompt_+="$_bold$_user_color"'[${USER}@\h] '"$_reset"
    # PWD
    _prompt_+="$_user_color\w$_reset\n"
    # Prompt line
    _prompt_+="$_bold"'[\$] '"$_reset"
}

_prompt() {
    _get_prompt
    PS1="$_prompt_"
}

if [ -n "$BASH_VERSION" ]; then
    PROMPT_COMMAND+=( _prompt )
    # Separator before each output 
    PS0='$(tput dim; _prompt_sep; tput sgr0;)'
elif [ -n "$ZSH_VERSION" ]; then
    precmd() {
        _get_prompt
        _prompt_=$(echo $_prompt_ | sed 's/%/%%/g')
        _prompt_=$(echo $_prompt_ | sed 's/\\\[/%{/g')
        _prompt_=$(echo $_prompt_ | sed 's/\\\]/%}/g')
        _prompt_=$(echo $_prompt_ | sed 's/\\h/%m/g')
        _prompt_=$(echo $_prompt_ | sed 's/\\w/%~/g')
        PROMPT=$_prompt_
    }
    preexec() {
        tput dim
        _prompt_sep
        tput sgr0
    }
fi