
## About

This is a chain of provisioning scripts for setting up your macOS (and Linux).  
But it's adjusted to my own use cases.

I am glad if you got a good reference for your provisioning.

## How to use (macOS)

1. Sign in iCloud on your macOS via GUI.
2. Install the "git" command to your macOS.

```shellsession
xcode-select --install
```

3. Execute a command on your terminal as follows:

```shellsession
curl -L --proto-redir -all,https 'https://raw.githubusercontent.com/mazgi/.dotfiles/master/setup/setup.sh' | bash
```

### After execution

- Create the `~/.gitconfig.local` file

## How to develop

1. Fork this repository.

2. Clone.

```shellsession
$ git clone git@github.com:${YOUR_NAMESPACE}/.dotfiles.git ~/.dotfiles
$ cd ~/.dotfiles
$ git submodule update --init --recursive
```

3. Create symlinks.

First, go to your home directory.

```shellsession
$ cd
```

**Use `zsh`** with `~/.zshrc`.

```shellsession
$ ln -s .dotfiles/zsh/.zshrc .
$ chsh -s /bin/zsh
Changing shell for YOUR_NAME.
Password for YOUR_NAME: 
```

**Use `vim`** with `~/.vimrc` and `~/.vim` directory.

```shellsession
$ ln -s .dotfiles/vim/.vim* .
$ vim
```

And run `:BundleInstall` on your vim.
