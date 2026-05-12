#!/usr/bin/env bash

_skillsmcp() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local opts="search list config help"
    local search_opts="--limit --page --sort"
    local config_opts="show paths add-path default set-default"

    # Top-level commands
    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=($(compgen -W "$opts" -- "$cur"))
        return 0
    fi

    # Command-specific options
    case "${COMP_WORDS[1]}" in
        search)
            if [[ $COMP_CWORD -eq 2 ]]; then
                COMPREPLY=($(compgen -W "$search_opts" -- "$cur"))
            fi
            ;;
        list)
            # No additional options
            ;;
        config)
            if [[ $COMP_CWORD -eq 2 ]]; then
                COMPREPLY=($(compgen -W "$config_opts" -- "$cur"))
            elif [[ "$prev" == "add-path" ]]; then
                _filedir -d
            elif [[ "$prev" == "set-default" ]]; then
                COMPREPLY=($(compgen -W "global local" -- "$cur"))
            fi
            ;;
    esac
}

complete -F _skillsmcp skillsmcp