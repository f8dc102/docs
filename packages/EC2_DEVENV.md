# INSTRUCTIONS

## Setup Development Environment

### Cloud-init Configuration

```yaml
#cloud-config
package_update: true
package_upgrade: true

packages:
  - git
  - zsh
  - unzip
  - gettext
  - build-essential
  - mosh
  - cmake
  - screen
  - tmux

# default user settings
system_info:
  default_user:
    name: f8dc193
    shell: /bin/zsh

runcmd:
  # Install OhMyZsh
  - chsh -s $(which zsh) f8dc193
  - su - f8dc193 -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
  # Install Powerlevel10k
  - su - f8dc193 -c "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/' ~/.zshrc"
  # Install Zsh Syntax Highlighting
  - su - f8dc193 -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && sed -i '/plugins=(git)/c\plugins=(git zsh-syntax-highlighting)' ~/.zshrc"
  # Finally Reboot the System
  - reboot
```

### Add Auto-Stop Service

```bash
sudo bash -c 'cat > /etc/systemd/system/autostop.service <<EOF
[Unit]
Description=AutoStop

[Service]
Type=simple
ExecStart=/usr/local/bin/autostop.sh

[Install]
WantedBy=multi-user.target
EOF'
```

```bash
sudo bash -c 'cat > /usr/local/bin/autostop.sh <<EOF
#!/bin/bash

LOGFILE=/var/log/autostop.log

# Reset Counter
counter=0

# Print Start Message
echo "\$(date): Starting Autostop Script." >>\$LOGFILE

# Loop
while true; do
  # Check SSH Connection Established on Port 22
  connections=\$(/usr/bin/ss -tnp | /bin/grep ":22" | /bin/grep ESTAB)

  # If There is No Active Connection, Then
  if [ -z "\$connections" ]; then
    # Increment Counter
    counter=\$((counter + 1))
    echo "\$(date): No SSH Connection. Counter: \$counter" >>\$LOGFILE

    # If The Counter Reaches 10 (10 minutes)
    if [ \$counter -ge 10 ]; then
      echo "\$(date): Counter Reached 10, Poweroff." >>\$LOGFILE
      /usr/sbin/shutdown -h now
      exit
    fi
  else
    # Else, Reset Counter
    counter=0
    echo "\$(date): Active SSH Connection Found, Resetting Counter." >>\$LOGFILE
  fi

  # Wait a minute
  /bin/sleep 60
done
EOF'
```

```bash
# Change Permission and Enable Service
sudo chmod +x /usr/local/bin/autostop.sh
sudo systemctl enable autostop.service
sudo systemctl start autostop.service

# Check Status
sudo systemctl status autostop.service
```

### Install NeoVim and LazyVim

```bash
# Go to Home Directory and Clone NeoVim
cd && git clone https://github.com/neovim/neovim

# Go to NeoVim Directory and Build
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo

# Install NeoVim
sudo make install

# Clean Up
cd && sudo rm -rf neovim

# Install LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim

# Remove Git Directory and Open NeoVim to Install LazyVim
rm -rf ~/.config/nvim/.git && nvim
```

### Install JDK (Corretto 21)

```bash
# To use the Corretto Apt repositories on Debian-based systems, such as Ubuntu, import the Corretto public key and then add the repository to the system list by using the following commands:
wget -O - https://apt.corretto.aws/corretto.key | sudo gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg && \
echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | sudo tee /etc/apt/sources.list.d/corretto.list

# After the repo has been added, you can install Corretto 23 by running this command:
sudo apt-get update; sudo apt-get install -y java-23-amazon-corretto-jdk
```

### Install Rust and Node.js using nvm

```bash
# Install Rust and Node.js
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

# Reload Shell
source $HOME/.cargo/env
source ~/.zshrc

# Install Node.js
nvm install 22
```

### Install General Packages

```bash
sudo apt install -y clangd python3.12-full python3-pip php php-cli ruby fish luarocks fd-find golang xsel fzf maven gradle tree
curl -fsSL https://install.julialang.org | sh
```

Maybe useful if you are in arm64 architecture.

```bash
ln -s /usr/bin/clangd ~/.local/share/nvim/mason/bin/clangd
mkdir ~/.local/share/nvim/mason/packages/clangd
```

Install lazygit

```bash
# Download and Install LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
# Change the following URL if you are in different architecture.
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_arm64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# Clean Up
rm -rf lazygit*
```

Install NeoVim providers and plugins etc.

```bash
# Install NeoVim Providers
pip3 install neovim --break-system-packages
npm install -g neovim

# Install NeoVim Plugins
pip3 install sqlfluff --break-system-packages
pip3 install tiktoken --break-system-packages
npm install -g tree-sitter-cli
npm install -g markdown-toc
npm install -g markdownlint-cli2
npm install -g prettier
cargo install ripgrep
```

Install PHP Composer

```bash
# Download and Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

# Move Composer to bin directory
sudo mv composer.phar /usr/local/bin/composer
```

### Install Docker

```bash
# Set up Docker's apt repository.
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

### Reboot

```bash
# To apply all changes, reboot the system.
sudo reboot
```

### Git Configuration

```bash
# Change default branch name to main
git config --global init.defaultBranch main

# Set User Name and Email
git config --global user.name "{name}"
git config --global user.email "{email}"

# Change Editor to NeoVim
git config --global core.editor "nvim"
# Test Editor
git config --global --edit

# Create SSH Key
ssh-keygen -t ed25519 -C "{email}"

# Add SSH Key to SSH Agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy SSH Key And Add to [GitHub](https://github.com/settings/keys)
cat ~/.ssh/id_ed25519.pub
```
