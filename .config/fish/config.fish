if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx FNM_DIR $HOME/.local/share/fnm
set -gx PATH $FNM_DIR $FNM_DIR $PATH
eval (fnm env --use-on-cd | source)
abbr --add gc "git clone "
abbr --add ga "git add ."
abbr --add gcm "git commit -m "
abbr --add gpo "git push origin"
abbr --add gpl "git pull origin"


# Colored man pages
set -gx LESS_TERMCAP_mb (printf '\e[1;31m')  # blinking
set -gx LESS_TERMCAP_md (printf '\e[1;36m')  # bold
set -gx LESS_TERMCAP_me (printf '\e[0m')     # reset
set -gx LESS_TERMCAP_so (printf '\e[1;44;33m') # standout
set -gx LESS_TERMCAP_se (printf '\e[0m')
set -gx LESS_TERMCAP_us (printf '\e[1;32m')  # underline
set -gx LESS_TERMCAP_ue (printf '\e[0m')
