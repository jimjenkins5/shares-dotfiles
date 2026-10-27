script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/prompt.sh"

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias ag='ag --pager="less -r"'

# HTTPie over https shorthand
alias https="http --default-scheme=https"

# weather in bash
alias weather="curl wttr.in/19104"

# use WezTerm ssh
if command -v wezterm >/dev/null 2>&1; then
  alias wssh='wezterm ssh'
fi
