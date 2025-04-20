# Add the following to .zshrc:
# if [[ -f ~/.zsh/prompt.zsh ]]; then
#     source ~/.zsh/prompt.zsh
# fi

# Git prompt function
prompt_git() {
	local s=''
	local branchName=''

	# Check if the current directory is in a Git repository.
	# Use command git to avoid conflict with any 'git' alias
	command git rev-parse --is-inside-work-tree &>/dev/null || return

	# Check for what branch we’re on.
	branchName="$(command git symbolic-ref --quiet --short HEAD 2> /dev/null || \
		command git describe --all --exact-match HEAD 2> /dev/null || \
		command git rev-parse --short HEAD 2> /dev/null || \
		echo '(unknown)')"

	# Check Git status
	repoUrl="$(command git config --get remote.origin.url)"
	# Early exit for Chromium & Blink repo, as the dirty check takes too long.
	if grep -q 'chromium/src.git' <<< "${repoUrl}"; then
		s+='*'
	else
		# Check for uncommitted changes in the index.
		if ! command git diff --quiet --ignore-submodules --cached; then
			s+='+'
		fi
		# Check for unstaged changes.
		if ! command git diff-files --quiet --ignore-submodules --; then
			s+='!'
		fi
		# Check for untracked files.
		if [ -n "$(command git ls-files --others --exclude-standard)" ]; then
			s+='?'
		fi
		# Check for stashed files.
		if command git rev-parse --verify refs/stash &>/dev/null; then
			s+='$'
		fi
	fi

	[ -n "${s}" ] && s=" [${s}]"

	# Use print for potentially better handling of escapes in Zsh, though echo -e often works
	# Pass through the color codes received as arguments
	print -Pn -- "${1}${branchName}${2}${s}"
}

# Color setup using tput
if tput setaf 1 &> /dev/null; then
	tput sgr0 # reset colors
	bold=$(tput bold)
	reset=$(tput sgr0)
	# Solarized colors
	black=$(tput setaf 0)
	blue=$(tput setaf 33)
	cyan=$(tput setaf 37)
	green=$(tput setaf 64)
	orange=$(tput setaf 166)
	purple=$(tput setaf 125)
	red=$(tput setaf 124)
	violet=$(tput setaf 61)
	white=$(tput setaf 15)
	yellow=$(tput setaf 136)
else
	# Fallback ANSI escape codes
	bold='\e[1m'
	reset='\e[0m'
	black='\e[1;30m'
	blue='\e[1;34m'
	cyan='\e[1;36m'
	green='\e[1;32m'
	orange='\e[1;33m'
	purple='\e[1;35m'
	red='\e[1;31m'
	violet='\e[1;35m'
	white='\e[1;37m'
	yellow='\e[1;33m'
fi

# Style definitions
# Highlight the user name when logged in as root.
if [[ "${UID}" -eq 0 ]]; then
	userStyle="${red}"
else
	userStyle="${orange}"
fi

# Highlight the hostname when connected via SSH.
if [[ -n "${SSH_TTY}" ]]; then
	hostStyle="${bold}${red}"
else
	hostStyle="${yellow}"
fi

# Enable substitution in the prompt string
setopt PROMPT_SUBST

# Zsh prompt structure
# Use %{...%} to wrap non-printing ANSI escape codes
# Use Zsh prompt escapes: %n (username), %m (hostname), %d (full path), %# (prompt symbol)

# Optional: Set terminal title (using %1~ for basename of current dir)
# print -Pn "\033]0;%1~\a"

PROMPT=""
PROMPT+=$'\n' # Newline
PROMPT+="%{${bold}%}" # Bold on
PROMPT+="%{${userStyle}%}%n%{${white}%}@%{${hostStyle}%}%m%{${white}%} in %{${green}%}%d" # user@host in /full/path
PROMPT+="%{${reset}%}" # Reset colors/styles before git info
# Call prompt_git, passing ANSI color codes. The output (including codes) will be substituted.
# Note: The ANSI codes ($white, $violet, $blue) are passed directly.
PROMPT+='$(prompt_git "%{${white}%} on %{${violet}%}" "%{${blue}%}")'
PROMPT+=$'\n' # Newline before the prompt character
PROMPT+="%{${white}%}%# %{${reset}%}" # Prompt symbol ($ or #) in white, followed by reset

# Continuation prompt (PS2)
PS2="%{${yellow}%}→ %{${reset}%}"

# Clean up variables (optional)
unset bold reset black blue cyan green orange purple red violet white yellow userStyle hostStyle
