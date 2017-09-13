## How to use

1. Fork this repository.

2. Clone.

```shellsession
$ git clone git@github.com:${YOUR_NAMESPACE}/.dotfiles.git ~/.dotfiles
$ cd ~/.dotfiles
$ git submodule update --init --recursive
```

3. Create symlinks.

Go to your home directory.

```shellsession
$ cd
```

```shellsession
$ ln -s .dotfiles/zsh/.zshrc .
```
