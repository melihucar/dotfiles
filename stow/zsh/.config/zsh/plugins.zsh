# Minimal plugin loader: git-clone on first use, `zplug-update` to pull all.
ZPLUGDIR="$XDG_DATA_HOME/zsh/plugins"

_zplug() {
  local repo=$1 name=${1:t}
  if [[ ! -d $ZPLUGDIR/$name ]]; then
    print -P "%F{blue}zsh:%f installing $repo"
    git clone --quiet --depth 1 "https://github.com/$repo" "$ZPLUGDIR/$name"
  fi
}

zplug-update() {
  local d
  for d in $ZPLUGDIR/*(/); do print "updating ${d:t}"; git -C $d pull --quiet --ff-only; done
}

_zplug zsh-users/zsh-completions
_zplug zsh-users/zsh-autosuggestions
_zplug zsh-users/zsh-syntax-highlighting   # sourced at the end of .zshrc

fpath=("$ZPLUGDIR/zsh-completions/src" $fpath)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
source "$ZPLUGDIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
