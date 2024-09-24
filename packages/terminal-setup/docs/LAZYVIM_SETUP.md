# LazyVim Setup

Build Neovim

```bash
git clone https://github.com/neovim/neovim && cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
```

If you want stable release, also run:

```bash
git chcekout stable
```

Finally, install Neovim:

```bash
sudo make install
```

Let's install LazyVim:

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim && rm -rf ~/.config/nvim/.git && nvim
```

Run :checkhealth to see if everything is working properly.

```
:checkhealth
```

```bash
:LazyHealth
```

After running the above command, you will need to fix that has error or warning. Just step by step.

If you're at aarch64, you might need to link clangd installed with apt.

```bash
sudo apt install clangd
ln -s /usr/bin/clangd ~/.local/share/nvim/mason/bin/clangd
mkdir ~/.local/share/nvim/mason/packages/clangd
```
