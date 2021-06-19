import XMonad
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Util.Run(spawnPipe, hPutStrLn)
import XMonad.Util.SpawnOnce
import XMonad.Hooks.ManageDocks
import XMonad.Layout.LayoutModifier
import XMonad.Hooks.DynamicLog(dynamicLogWithPP, wrap, xmobarPP, xmobarColor,defaultPP ,shorten, PP(..))
import XMonad.Layout.Spacing
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.SetWMName
import Graphics.X11.ExtraTypes.XF86
import Control.Monad
import Data.Maybe
import Data.List

myTerminal      = "st -e fish"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myBorderWidth   = 3

myModMask       = mod4Mask

font :: String
font = "xft:FiraMono Nerd Font:size=10:antialias=true:hinting=true"
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]
--myWorkspaces    = ["1","2","3","4","5",]
-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#44475a"
myFocusedBorderColor = "#bd93f9"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)

    , ((modm,               xK_space), spawn "exe=`dmenu_run -fn 'Liberation Sans' -nb '#282a36' -nf '#bd93f9' -sb '#f1fa8c' -sf '#282a36' -h 23` && eval \"exec $exe\"")

    , ((modm,		    xK_p     ), spawn "gmrun")

    , ((modm,		    xK_w     ), kill)

    , ((modm .|. shiftMask, xK_space ), sendMessage NextLayout)

    , ((modm,               xK_Tab   ), windows W.focusDown)

    , ((modm,               xK_j     ), windows W.focusDown)

    , ((modm,               xK_k     ), windows W.focusUp  )

    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)

    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    , ((modm,               xK_h     ), sendMessage Shrink)

    , ((modm,               xK_l     ), sendMessage Expand)

    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    , ((modm,		    xK_comma ), sendMessage (IncMasterN 1))

    , ((modm,		    xK_period), sendMessage (IncMasterN (-1)))


    , ((0,		    xK_Print), spawn "flameshot gui")
    , ((0,		    xF86XK_AudioRaiseVolume), spawn "amixer set Master 5%+")
    , ((0,		    xF86XK_AudioLowerVolume), spawn "amixer set Master 5%-")
    , ((0,		    xF86XK_AudioMute), spawn "amixer set Master toggle")
    , ((0,		    xF86XK_MonBrightnessUp), spawn "xbacklight -inc 5")
    , ((0,		    xF86XK_MonBrightnessDown), spawn "xbacklight -dec 5")
    , ((0,		    xF86XK_AudioPlay), spawn "playerctl play-pause")
    , ((0,		    xF86XK_AudioPrev), spawn "playerctl previous")
    , ((0,		    xF86XK_AudioNext), spawn "playerctl next")

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    , ((modm .|. shiftMask, xK_r     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++
    
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

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- * NOTE: XMonad.Hooks.EwmhDesktops users must remove the obsolete
-- ewmhDesktopsLayout modifier from layoutHook. It no longer exists.
-- Instead use the 'ewmh' function from that module to modify your
-- defaultConfig as a whole. (See also logHook, handleEventHook, and
-- startupHook ewmh notes.)
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

myLayout = ( mySpacing 5 ( avoidStruts (tiled ||| Full) ) )
    where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

-------------------------------------
-- Adding fullscreen support to xmoand
setFullscreenSupported :: X ()
setFullscreenSupported = addSupported ["_NET_WM_STATE", "_NET_WM_STATE_FULLSCREEN"]

addSupported :: [String] -> X ()
addSupported props = withDisplay $ \dpy -> do
    r <- asks theRoot
    a <- getAtom "_NET_SUPPORTED"
    newSupportedList <- mapM (fmap fromIntegral . getAtom) props
    io $ do
      supportedList <- fmap (join . maybeToList) $ getWindowProperty32 dpy a r
      changeProperty32 dpy r a aTOM propModeReplace (nub $ newSupportedList ++ supportedList)

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
    [ className =? "Chromium"		-->	doShift ( myWorkspaces !! 2 )
    , className =? "discord"		-->	doShift ( myWorkspaces !! 3 )
    , className =? "TelegramDesktop"	-->	doShift ( myWorkspaces !! 4 )
    , className =? "Spotify"		-->	doShift ( myWorkspaces !! 5 )]

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
--myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add initialization of EWMH support to your custom startup
-- hook by combining it with ewmhDesktopsStartup.
--
myStartupHook :: X ()
myStartupHook = do
        spawnOnce "xsetroot -cursor_name left_ptr &"
        spawnOnce "dunst &"
        spawnOnce "flameshot &"
        spawnOnce "xrdb merge ~/.Xresources &"
        spawnOnce "feh --bg-fill /home/triplek/Pictures/wallpapers/gentoo-drac.png"
        spawnOnce "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 > /dev/null 2>&1"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
       xmproc <- spawnPipe "xmobar ~/.xmobarrc"
       xmonad $ docks $ ewmh def {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
        layoutHook         = myLayout,
        manageHook         = manageDocks <+> manageHook def,
        handleEventHook    = myEventHook <+> fullscreenEventHook,
        logHook            = dynamicLogWithPP xmobarPP 
                        { ppOutput = hPutStrLn xmproc
                        , ppCurrent = xmobarColor "#8be9fd" "" . wrap "[" "]"
                        , ppVisible = xmobarColor "#bd93f9" ""  
                        , ppHidden = xmobarColor "#bd93f9" "" . wrap "*" ""		-- Hidden workspaces
                        , ppHiddenNoWindows = xmobarColor "#bd93f9" ""			-- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor "#bd93f9" "" . shorten 60               -- Title of active window
                        , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
                        , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace

                        },
        startupHook        = setFullscreenSupported >> setWMName "Xmonad" <+> myStartupHook
    }
