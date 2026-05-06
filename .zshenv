# Environment shared by every zsh process.
export VISUAL="code --wait"
export EDITOR="$VISUAL"

export XDG_CONFIG_HOME="$HOME/.config"
export WEZTERM_CONFIG_FILE="$XDG_CONFIG_HOME/wezterm/wezterm.lua"
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"
export PYENV_ROOT="$HOME/.pyenv"
export UIDOTSH_TOKEN="API_TOKEN"

# Use zsh's tied path array so entries stay unique across nested shells.
typeset -U path PATH
path=(
	"$HOME/.local/bin"
	"$HOME/.yarn/bin"
	"$HOME/.config/yarn/global/node_modules/.bin"
	"$PYENV_ROOT/bin"
	"$HOME/.jenv/bin"
	"/opt/homebrew/bin"
	"/opt/homebrew/sbin"
	"/opt/homebrew/opt/postgresql@17/bin"
	"/opt/homebrew/opt/rustup/bin"
	$path
)
