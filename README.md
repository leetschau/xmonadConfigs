# XMonad on Mint 20.1

## Overview

To use XMonad on Mint, there're basically 4 steps:

1. Build XMonad from sources with stack;
1. Add XMonad to xinitrc;
1. Generate configuration files;
1. Start XMonad.

Why we must build from sources instead of installing pre-build binary
packages via `apt` or `dnf`?
The reason is the [XMonad Configuration Tutorial][tutorial]
for now (2021.8.3) is based on the current version (xmonad 0.16 + xmonad-contrib 0.17).
The current version of XMonad is 0.16.9999.
While the version in `apt`, `dnf` and `stackage` are both 0.15.
And the changes between 0.15 and 0.16 are large.

## Build from sources

Build xmonad, xmobar and xmonad-contrib from sources with `stack`
according to [How to install xmonad and xmobar via stack][instack].
The latter two packages depend on xmonad, so you must build them together:

    sudo apt install libasound2-dev
    take ~/.xmonad
    git clone "https://github.com/xmonad/xmonad" xmonad-git
    git clone "https://github.com/xmonad/xmonad-contrib" xmonad-contrib-git
    git clone "https://github.com/jaor/xmobar" xmobar-git
    stack init  # create stack.yaml file in current dir

    cat << EOF >> stack.yaml
    flags:
      xmobar:
        all_extensions: true
    extra-deps:
      - netlink-1.1.1.0@sha256:d83424b5ba9921191449e4b1f53c7cba7f4375f2c55a9b737c77e982e1f40d00,3689
    EOF

    stack install

    cat << EOF > build
    #!/bin/sh
    exec stack ghc -- \
      --make xmonad.hs \
      -i \
      -ilib \
      -fforce-recomp \
      -main-is main \
      -v0 \
      -o "$1"
    EOF

    chmod a+x build

    xmonad --recompile
    xmonad --restart

### Update XMonad

In the future you can update XMonad with:

1. Update source codes in the 3 repos with `git pull`;
1. `stack install` to update `xmonad` and `xmobar`.

Note:

libasound2-dev is installed to fix error `alsa-core > version ==1.0.14 || >1.0.14 is required but it could not be found`
during `stack install`.

## Add to Startup Script

Install other tools and add them into [.xinitrc](./.xinitrc):
```
sudo apt install stalonetray rxvt-unicode feh
```

Here *stalonetray* is a system tray application.

## Configuration

Following [XMonad Configuration Tutorial][tutorial],
there're totoally 3 configurations:

* [xmonad.hs](./xmonad.hs)
* [xmobarrc](./xmobarrc)
* [.stalonetrayrc](./.stalonetrayrc)

## Start XMonad

Make system start in text interface (runlevel 3) and restart:

    sudo systemctl set-default multi-user.target
    sudo reboot
    startx

## Switch between developing and monitor mode

Run script `monitor-mode` to switch to *monitor* mode,
while switch to *develop mode* with `develop-mode`.




[xmonad-git]: https://github.com/xmonad/xmonad

[xmonad-contrib]: https://github.com/xmonad/xmonad-contrib

[tutorial]: https://github.com/xmonad/xmonad/blob/master/TUTORIAL.md

[instack]: https://brianbuccola.com/how-to-install-xmonad-and-xmobar-via-stack/

