Dotfiles
========

Early PoC for chezmoi

Dependencies:

There is a catch 22, you'll need to manually install [ubi](https://github.com/houseabsolute/ubi/releases) and [age-plugin-yubikey](https://github.com/str4d/age-plugin-yubikey/releases/tag/v0.5.0)
for a first run


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
