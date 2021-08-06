import XMonad

import System.Exit
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Ungrab

import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition

import qualified XMonad.StackSet as W

main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig

myTerminal = "urxvt"
myConfig = def
    { terminal = myTerminal
    , modMask = mod1Mask
    , layoutHook = myLayout
    , manageHook = myManageHook
    , normalBorderColor  = "#000000"
    , focusedBorderColor = "#00ff00"
    }
  `removeKeys` [ (mod1Mask, xK_Return) ]
  `additionalKeys` [ ((mod1Mask, xK_Return), spawn myTerminal) ]
  `additionalKeysP`
    [ ("M-C-s", spawn "systemctl suspend" )
    , ("M-S-f", spawn "firefox" )
    , ("M-S-e", io (exitWith ExitSuccess))
    , ("M-S-q", kill)
    , ("<Print>", spawn "flameshot gui" )
    , ("M-d", spawn "dmenu_run")
    , ("M-s", windows W.swapMaster)
    ]

myLayout = Mirror tiled ||| Full ||| tiled
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1
    ratio   = 3/4
    delta   = 3/100

myManageHook = insertPosition Below Newer

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Bottom" "#8be9fd" 4
    , ppHidden          = yellow . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (red "!") (red "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#ffff00" ""
    red      = xmobarColor "#ff0000" ""
    lowWhite = xmobarColor "#666666" ""
