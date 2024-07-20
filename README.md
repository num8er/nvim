# NeoVim Configuration

## Cloned from starter template of LazyVim

Requirements:

1. latest NeoVim
2. git
3. lsp-s for language support

---

Using this configuration:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mkdir -p ~/.config/nvim
git clone https://github.com/num8er/nvim.git ~/.config/nvim

nvim
```

Extra:

Add aliases to your shell configuration files if you want to use `nvim` instead of `vim` in

bash:
`echo "alias vim='nvim'" >> ~/.bashrc `

zsh:
`echo "alias vim='nvim'" >> ~/.zshrc `
