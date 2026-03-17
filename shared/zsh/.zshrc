PATH="$HOME/.config/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/.bun/bin:$PATH"
PATH="$HOME/.local/share/mise/shims:$PATH"

PROMPT='%2~ %# '


# OSX
if [[ "$OSTYPE" == darwin* ]]; then
  # Syntax highlighting
  if [ -n "${HOMEBREW_PREFIX:-}" ]; then
    if [ -r "${HOMEBREW_PREFIX}/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]; then
      source "${HOMEBREW_PREFIX}/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
    fi
    if [ -r "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
      source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    fi
  fi
fi
