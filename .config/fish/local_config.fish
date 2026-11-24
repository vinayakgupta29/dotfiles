
set -gx FNM_DIR $HOME/.local/share/fnm
set -gx PATH $FNM_DIR $FNM_DIR $PATH

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/home/zoro/.opam/opam-init/init.fish' && source '/home/zoro/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration


# Added by Antigravity CLI installer
set -gx PATH "/home/zoro/.local/bin" $PATH

