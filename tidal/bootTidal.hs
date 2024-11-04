:set -XOverloadedStrings
:set prompt ""

import Sound.Tidal.Context
import System.IO (hSetEncoding, stdout, utf8)
hSetEncoding stdout utf8


:{

let target =
      Target {oName = "visualiser",   -- A friendly name for the target (only used in error messages)
              oAddress = "0.0.0.0", -- The target's network address, normally "localhost"
              oPort = 3333,           -- The network port the target is listening on
              oLatency = 0.19,         -- Additional delay, to smooth out network jitter/get things in sync
              oSchedule = Live,       -- The scheduling method - see below
              oWindow = Nothing,      -- Not yet used
              oHandshake = False,     -- SuperDirt specific
              oBusPort = Nothing      -- Also SuperDirt specific
             }
    oscplay = OSC "/play" $ ArgList [
                              ("n", Just $ VI 0), 
                              ("s", Nothing), 
                              ("channel", Just $ VI 1), 
                              ("amp", Just $ VI 1), 
                              ("inst", Just $ VS "unknown"), 
                              ("cps", Just $ VF 0), 
                              ("cycle", Just $ VF 0), 
                              ("delta", Just $ VF 0), 
                              ("portamento", Just $ VI 0),
                              ("rate", Just $ VF 0), 
                              ("legato", Just $ VF 0)
                            ]
     
    inst = pS "inst"

:}

:{
let oscmap = [(target, [oscplay]),
              (superdirtTarget, [superdirtShape])
             ]
:}

tidal <- startStream defaultConfig oscmap

:{
let p = streamReplace tidal
    hush = streamHush tidal
    list = streamList tidal
    mute = streamMute tidal
    unmute = streamUnmute tidal
    solo = streamSolo tidal
    unsolo = streamUnsolo tidal
    once = streamOnce tidal
    first = streamFirst tidal
    asap = once
    nudgeAll = streamNudgeAll tidal
    all = streamAll tidal
    resetCycles = streamResetCycles tidal
    setcps = asap . cps
    xfade i = transition tidal True (Sound.Tidal.Transition.xfadeIn 4) i
    xfadeIn i t = transition tidal True (Sound.Tidal.Transition.xfadeIn t) i
    histpan i t = transition tidal True (Sound.Tidal.Transition.histpan t) i
    wait i t = transition tidal True (Sound.Tidal.Transition.wait t) i
    waitT i f t = transition tidal True (Sound.Tidal.Transition.waitT f t) i
    jump i = transition tidal True (Sound.Tidal.Transition.jump) i
    jumpIn i t = transition tidal True (Sound.Tidal.Transition.jumpIn t) i
    jumpIn' i t = transition tidal True (Sound.Tidal.Transition.jumpIn' t) i
    jumpMod i t = transition tidal True (Sound.Tidal.Transition.jumpMod t) i
    mortal i lifespan release = transition tidal True (Sound.Tidal.Transition.mortal lifespan release) i
    interpolate i = transition tidal True (Sound.Tidal.Transition.interpolate) i
    interpolateIn i t = transition tidal True (Sound.Tidal.Transition.interpolateIn t) i
    clutch i = transition tidal True (Sound.Tidal.Transition.clutch) i
    clutchIn i t = transition tidal True (Sound.Tidal.Transition.clutchIn t) i
    anticipate i = transition tidal True (Sound.Tidal.Transition.anticipate) i
    anticipateIn i t = transition tidal True (Sound.Tidal.Transition.anticipateIn t) i
    forId i t = transition tidal False (Sound.Tidal.Transition.mortalOverlay t) i
    d1 = p 1 . (|< orbit 0)
    d2 = p 2 . (|< orbit 1)
    d3 = p 3 . (|< orbit 2)
    d4 = p 4 . (|< orbit 3)
    d5 = p 5 . (|< orbit 4)
    d6 = p 6 . (|< orbit 5)
    d7 = p 7 . (|< orbit 6)
    d8 = p 8 . (|< orbit 7)
    d9 = p 9 . (|< orbit 8)
    d10 = p 10 . (|< orbit 9)
    d11 = p 11 . (|< orbit 10)
    d12 = p 12 . (|< orbit 11)
    d13 = p 13
    d14 = p 14
    d15 = p 15
    d16 = p 16
    o pitch = n pitch # s "pitch" 
    octave octave = stepsPerOctave octave
    volt volt = n volt # s "voltage"
    g gate = n gate # s "gate" # legato 0.1 # amp 0.4
    clock = rate "[1 0]*2" # s "voltage"
    ar w x = attack w # decay x # s "ar"
    adsr w x y z = attack w # decay x # sustain y # release z # s "ar"
    sawt x = rate x # s "saw"
    lfo x = rate x # s "lfo"
    x x = channel (x - 1) 
    glide p r = portamento p # rate r
    v o = orbit (o - 1)
    l x = legato x
    j1 x = jumpMod 1 x
    j2 x = jumpMod 2 x
    j3 x = jumpMod 3 x
    j4 x = jumpMod 4 x
    j5 x = jumpMod 5 x
    j6 x = jumpMod 6 x
    j7 x = jumpMod 7 x
    j8 x = jumpMod 8 x
    b b = cps (270 / 60 / b)
    ff nn = n nn # s "vrm" |- n 60
    drum :: Pattern String -> ControlPattern
    drum = n . (subtract 24 . drumN <$>)
    drumN :: Num a => String -> a
    drumN "k" = 0
    drumN "s" = 2
    drumN "c" = 3
    drumN "o" = 10
    drumN "h" = 8
    drumN "l" = 9
    drumN "m" = 14
    drumN "j" = 13
    drumN "p" = 15
    drumN "t" = 20
    drm2 x = drum x # s "drm" # amp 1 # nudge 0.042 # inst "drum"
    lxrd :: Pattern String -> ControlPattern
    lxrd = channel . (subtract 1 . lxrdChannel <$>)
    lxrdChannel :: Num a => String -> a
    lxrdChannel "k" = 9
    lxrdChannel "s" = 12  
    lxrdChannel "c" = 13
    lxrdChannel "o" = 15
    lxrdChannel "h" = 14
    lxrdChannel "l" = 10
    lxrdChannel "m" = 11
    lxr2 x = lxrd x # g 1 # l 0.1 # amp 0.1 # inst "drum"
    accent = g 1 # x 16 # legato 1 # cut 69
    lxr = inhabit [("k", g 1 # legato 0.005 # x 9),
                    ("K", stack[g 1 # legato 0.005 # x 9, accent]),
                    ("l", g 1 # legato 0.005 # x 10),
                    ("L", stack[g 1 # legato 0.005  # x 10, accent]),
                    ("m", g 1 # legato 0.005 # x 11),
                    ("M", stack[g 1 # legato 0.005 # x 11, accent]),
                    ("s", g 1 # legato 0.005 # x 12),
                    ("S", stack [g 1 # legato 0.005 # x 12, accent]),
                    ("c", g 1 # legato 0.005 # x 13),
                    ("C", stack[g 1 # legato 0.005 # x 13, accent]),
                    ("h", g 1 # legato 0.005 # x 14),
                    ("H", stack[g 1 # legato 0.005 # x 14, accent]),
                    ("o", g 1 # legato 0.005 # x 15),
                    ("O", stack[g 1 # legato 0.005 # x 15, accent])]
    drm = inhabit [("k", drm2 "k" # amp 0.7),
                    ("K", drm2 "k"),
                    ("l", drm2 "l" # amp 0.7),
                    ("L", drm2 "l"),
                    ("m", drm2 "m" # amp 0.7),
                    ("M", drm2 "m"),
                    ("t", drm2 "t" # amp 0.7),
                    ("T", drm2 "t"),
                    ("s", drm2 "s" # amp 0.7),
                    ("S", drm2 "s"),
                    ("c", drm2 "c" # amp 0.7),
                    ("C", drm2 "c"),
                    ("h", drm2 "h" # amp 0.7),
                    ("H", drm2 "h"),
                    ("o", drm2 "o" # amp 0.7),
                    ("O", drm2 "o"),
                    ("j", drm2 "j" # amp 0.7),
                    ("J", drm2 "j"),
                    ("p", drm2 "p" # amp 0.7),
                    ("P", drm2 "p")]

:}

:{
let setI = streamSetI tidal
    setF = streamSetF tidal
    setS = streamSetS tidal
    setR = streamSetR tidal
    setB = streamSetB tidal
:}

:set prompt "tidal> "
:set prompt-cont ""
