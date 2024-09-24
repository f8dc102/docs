# Shell Setup
Install Oh My Zsh
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

If Default shell is not changed to zsh, change it by running
```bash
chsh -s $(which zsh)
```

Install powerlevel10k theme
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc && source ~/.zshrc
```

Install zsh-syntax-highlighting
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && sed -i '/plugins=(git)/c\plugins=(\n    git\n    zsh-syntax-highlighting\n)' ~/.zshrc && source ~/.zshrc
```

