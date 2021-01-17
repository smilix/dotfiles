# dotfiles

My base configs.

# Recommended tools

## fzf

```shell
sudo apt install fzf
# or
git clone --depth 1 --no-tags --single-branch --branch 0.25.0 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --bin
```

## exa

```shell
sudo apt install exa
# or
wget -O exa.zip https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip
sudo unzip exa.zip -d /usr/local/bin/ && rm exa.zip
sudo mv /usr/local/bin/exa-linux* /usr/local/bin/exa
```
