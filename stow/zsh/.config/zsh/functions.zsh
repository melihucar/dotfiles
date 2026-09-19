# mkdir + cd
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# yazi: cd into the directory you quit in
yy() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(<"$tmp")" && [[ -n $cwd && $cwd != $PWD ]]; then cd -- "$cwd"; fi
  rm -f -- "$tmp"
}

# start a new python project with uv (src layout, ruff, pytest)
pynew() {
  [[ -z $1 ]] && { echo "usage: pynew <name>"; return 1; }
  uv init --package "$1" && cd "$1" && uv add --dev ruff pytest && git add -A >/dev/null
}

# start a new Next.js app with pnpm + tailwind + eslint
nextnew() {
  [[ -z $1 ]] && { echo "usage: nextnew <name>"; return 1; }
  pnpm create next-app@latest "$1" --ts --tailwind --eslint --app --src-dir --use-pnpm --import-alias '@/*' && cd "$1"
}

# fuzzy-jump into a repo and open tmux session there
t() { tmux-sessionizer "$@"; }
