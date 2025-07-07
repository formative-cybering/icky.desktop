:set -fno-warn-orphans
:set -XMultiParamTypeClasses
:set -XOverloadedStrings
:set prompt ""

import Sound.Tidal.Boot
import Sound.Tidal.Context hiding (drum, drumN)
import System.IO (hSetEncoding, stdout, utf8)

default (Pattern String, Integer, Double)

-- Set UTF8 encoding
:{
let _ = hSetEncoding stdout utf8
:}

:{
let visualiserTarget = Target
      { oName = "visualiser"
      , oAddress = "0.0.0.0"
      , oPort = 1111
      , oLatency = 0.19
      , oSchedule = Live
      , oWindow = Nothing
      , oHandshake = False
      , oBusPort = Nothing
      }
:}

:{
let oscplayShape = OSC "/play" $ ArgList
      [ ("n", Just $ VI 0)
      , ("s", Nothing)
      , ("channel", Just $ VI 1)
      , ("amp", Just $ VI 1)
      , ("inst", Just $ VS "unknown")
      , ("cps", Just $ VF 0)
      , ("cycle", Just $ VF 0)
      , ("delta", Just $ VF 0)
      , ("portamento", Just $ VI 0)
      , ("rate", Just $ VF 0)
      , ("legato", Just $ VF 0)
      ]
:}

:{
let myOscMap =
      [ (visualiserTarget, [oscplayShape])
      , (superdirtTarget, [superdirtShape])
      ]
:}

tidalInst <- mkTidalWith myOscMap defaultConfig
instance Tidally where tidal = tidalInst

instance Tidally where tidal = tidalInst

-- Custom helpers (rename drum/drumN to myDrum/myDrumN as before)
:{
let inst = pS "inst"
    o pitch = n pitch # s "pitch"
    octave octave = stepsPerOctave octave
    volt volt = n volt # s "voltage"
    g gate = n gate # s "gate" # legato 0.1 # amp 0.4
    clock = rate "[1 0]*2" # s "voltage"
    ad w x = attack w # decay x # s "ar"
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

    arrange :: [(Time, Pattern a)] -> Pattern a
    arrange secs = _slow total $ timeCat fastened
      where total = sum $ fst <$> secs
            fastened = (\(cyc,sec) -> (cyc,_fast cyc $ sec)) <$> secs

    arrange' :: [(Time, [Pattern a])] -> Pattern a
    arrange' secs = _slow total $ timeCat fastened
      where total = sum $ fst <$> secs
            fastened = (\(cyc,sec) -> (cyc,_fast cyc $ stack sec)) <$> secs

    edo :: Double -> Pattern Double -> ControlPattern
    edo divisions notes =
      let
        notePos = notes * pure (12/divisions)
        midiNote = floor <$> notePos
        bendAmt = (notePos - (fromIntegral <$> midiNote)) * pure (16383/15)
      in stack
        [ n (fromIntegral <$> midiNote),
          midibend (min 16383 <$> bendAmt)
        ]

    vrm y z = n y # s "vrm" # midichan z
    vm z = vrm (-24) z # nudge 0.046 # amp 1
    timeLoop' n o f = timeLoop n $ (o <~) f
    timeLoop'' n o f = (o ~>) $ timeLoop n $ (o <~) f
    tl' = timeLoop'
    tl'' = timeLoop''
    ol z = n z # s "o" # v 3 # pan 1
    ar = arrange
    ar' = arrange'

    myDrum :: Pattern String -> ControlPattern
    myDrum = n . (subtract 24 . myDrumN <$>)

    myDrumN :: Num a => String -> a
    myDrumN "k" = 0
    myDrumN "s" = 2
    myDrumN "c" = 3
    myDrumN "o" = 10
    myDrumN "h" = 8
    myDrumN "l" = 9
    myDrumN "m" = 14
    myDrumN "j" = 13
    myDrumN "p" = 15
    myDrumN "t" = 20
    drm2 x = myDrum x # s "drm" # amp 1 # nudge 0.042 # inst "drum"

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

    setI = streamSetI
    setF = streamSetF
    setS = streamSetS
    setR = streamSetR
    setB = streamSetB
:}

enableLink

:set -fwarn-orphans
:set prompt "tidal> "
:set prompt-cont ""
