  -- Base
import XMonad
import System.Exit
import qualified XMonad.StackSet as W

-- Data
import qualified Data.Map as M

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName

-- Prompt
import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Shell

-- Utilities
import XMonad.Util.SpawnOnce

-- Variables
--
myFont :: String
myFont = "xft:DejaVu Sans:regular:size=10:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask

myTerminal :: String
myTerminal = "xterm"

myBrowser :: String
myBrowser = "firefox"

myEditor :: String
myEditor = myTerminal ++ " -e nvim"

myFileMan :: String
myFileMan = "pcmanfm"

myMailClient :: String
myMailClient = "thunderbird"

myBorderWidth :: Dimension
myBorderWidth = 0          -- Sets border width for windows

myNormColor :: String
myNormColor   = "#333"  -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#eee"  -- Border color of focused windows

-- Workspaces
--
myWorkspaces = ["www", "code", "term", "4", "5", "6", "7", "8", "9"]

-- Key bindings
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [
    -- launch terminal
    ((modm, xK_Return), spawn myTerminal)

    -- launch browser
    , ((modm, xK_w), spawn myBrowser)

    -- launch editor
    , ((modm, xK_e), spawn myEditor)

    -- launch file manager
    , ((modm, xK_f), spawn myFileMan)

    -- launch mail client
    --, ((modm, xK_m), spawn myMailClient)

    -- launch prompt
    , ((modm, xK_p), shellPrompt myXPConfig)

    -- close focused window
    , ((modm, xK_q), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )


    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))


    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm, xK_F10), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

-- Layouts
--
myLayout = tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , className =? "factorio"       --> doFullFloat
    , isFullscreen                  --> doFullFloat
    ] <+> manageDocks

------------------------------------------------------------------------
-- Event handling

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH event handling to your custom event hooks by
-- combining them with ewmhDesktopsEventHook.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH logHook actions to your custom log hook by
-- combining it with ewmhDesktopsLogHook.
--
myLogHook = fadeInactiveLogHook fadeAmount
	where fadeAmount = 0.90

-- Startup
--
myStartupHook :: X ()
myStartupHook = do
	spawnOnce "setxkbmap si &"
	spawnOnce "xset -dpms &"
	spawnOnce "xset s off &"
	spawnOnce "xsettingsd &"
	spawnOnce "lxpolkit &"
	spawnOnce "picom -b &"
	spawnOnce "nitrogen --restore &"
	spawnOnce "redshift &"
	setWMName "mknurs"

-- Bar
--
myBar = "xmobar $HOME/.config/xmobar/xmobarrc"

myPP = xmobarPP {
  ppCurrent = xmobarColor "#eee" "" . wrap "[" "]"
, ppTitle = xmobarColor "#eee" "" . shorten 60 
}

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)


-- Prompt
--

myXPConfig :: XPConfig
myXPConfig = def
      { font                = myFont
      , bgColor             = "#333"
      , fgColor             = "#eee"
      , bgHLight            = "#eee"
      , fgHLight            = "#333"
      , promptBorderWidth   = 0
      , position            = Top
      , height              = 20
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Just 100000  -- set Just 100000 for .1 sec
      -- , searchPredicate     = isPrefixOf
      , searchPredicate     = fuzzyMatch
      , alwaysHighlight     = True
      , maxComplRows        = Nothing      -- set to 'Just 5' for 5 rows
      }



main = xmonad =<< statusBar myBar myPP toggleStrutsKey defaults

defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        --focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        -- numlockMask deprecated in 0.9.1
        -- numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
