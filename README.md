Dotfiles
========

Early PoC for chezmoi

Dependencies:

There is a catch 22, you'll need to manually install:
* [ubi](https://github.com/houseabsolute/ubi/releases)
* [age-plugin-yubikey](https://github.com/str4d/age-plugin-yubikey/releases/tag/v0.5.0)
* [oh-my-zsh](https://ohmyz.sh/)
* [brew](https://brew.sh)
* `brew install mise tmux age`
* [patched fonts](https://github.com/powerline/fonts)

## WSL

```
winget install --interactive --exact dorssel.usbipd-win
```

```
usbipbd list
usbipd bind --busid <busid>
usbipd attach --wsl --busid <busid>
```

```
$ lsb
$ fix_wsl
```
