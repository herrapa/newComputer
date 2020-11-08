# Path to your oh-my-zsh installation.
export ZSH=/Users/jocke/.oh-my-zsh

export POD_LOCAL_HOME=/Users/jocke/Documents/utveckling/PodsLocal

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/jocke/Documents/blandat/mapnik-vector-tile/build/Release:$PATH"

export PATH="$HOME/.rbenv/shims:$PATH"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export PATH="$HOME/.fastlane/bin:$PATH"

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=sv_SE.UTF-8

# Ignore ORIG_HEAD from git-completion
zstyle ':completion:*:*' ignored-patterns '*ORIG_HEAD'

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias gs="git status"
alias gl="glol"

alias jira="git_current_branch | grep -o '[^/]*$' | xargs -I % open https://peroper.jira.com/browse/%"

alias dnsrefresh="sudo killall -HUP mDNSResponder"

# List all branches which are missing upstream branch ('gone') and prompts if it should remove them or not. (not force delete!)
git_rm_all_gone_branches() {
	git fetch -p > /dev/null 2>&1
	git branch -vv | grep -v '^*' | grep ": gone]" | awk '{ print $1 " " $2 " " $3 " " $4 }'
	echo "Do you want to delete the branches above?"
	select yn in "Yes" "Yes, force-delete" "No"; do
		case $yn in
			Yes ) git branch -vv | grep ": gone]" | awk '{print $1}' | xargs -n 1 git branch -d; break;;
			"Yes, force-delete" )  git branch -vv | grep ": gone]" | awk '{print $1}' | xargs -n 1 git branch -D; break;;
			No ) return;;
		esac
	done
}

ddsym() {
  echo "Download dSYM"
  cwd=$(pwd)
  did_pushd=false
  if [[ "PPBuildAgent" != "$(basename $(pwd))" ]]; then
    did_pushd=true
    pushd ~/Documents/utveckling/ppbuildagent
  fi
  bundle exec fastlane download_dsym version_number:$1
  if [ "$did_pushd" = true ]; then
    mv *.app.dSYM.zip ${cwd}/
    popd
  fi
}

edsym() {
  cwd=$(pwd)
  did_pushd=false
  if [[ "PPBuildAgent" != "$(basename $(pwd))" ]]; then
    did_pushd=true
    pushd ~/Documents/utveckling/ppbuildagent
  fi
  bundle exec fastlane extract_dsym uuid:$1
  if [ "$did_pushd" = true ]; then
    mv *.dSYM.zip ${cwd}/
    popd
  fi
}

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh