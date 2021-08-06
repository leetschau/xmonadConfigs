export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export LC_CTYPE=en_US.UTF-8
export EDITOR=nvim

xbindkeys
xmodmap -e "pointer = 3 2 1"
setxkbmap -option caps:swapescape -option ctrl:swap_lwin_lctl -option ctrl:swap_rwin_rctl

stalonetray &
fcitx &
copyq &
goldendict &
devmon &
flameshot &
feh --bg-fill --no-fehbg ~/Pictures/ui8VNo.webp

autocutsel -fork -selection CLIPBOARD
autocutsel -fork -selection PRIMARY

exec ~/.local/bin/xmonad

