# Put system-wide fish configuration entries here
# or in .fish files in conf.d/
# Files in conf.d can be overridden by the user
# by files with the same name in $XDG_CONFIG_HOME/fish/conf.d

# This file is run by all fish instances.
# To include configuration only for login shells, use
# if status is-login
#    ...
# end
# To include configuration only for interactive shells, use
# if status is-interactive
#   ...
# end

set fish_prompt_pwd_dir_length 0
fish_vi_key_bindings
alias config="git --git-dir=$HOME/.config/dotfiles --work-tree=$HOME"

# log everything
if test (string match '*clients*' (pwd) || string match '/*Global Networks*' (pwd)); and status is-interactive; and not set -q SCRIPT_RUNNING
	set -gx SCRIPT_RUNNING 1
	set logsdir $HOME/.logs/term/(date "+%Y/%m/%d/%H_%M_%S")
	mkdir -p $logsdir
	script -f $logsdir/(pwd | tr '/' '_').log
	end
# fix path
export PATH="/opt:$HOME/.local/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH"

