(

s.reboot {
    // Server options
    s.options.numBuffers = 1024 * 256; // increase this if you need to load more samples
    s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
    s.options.numWireBufs = 64; // increase this if you get "exceeded number of interconnect buffers" messages
    s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
    s.options.numOutputBusChannels = 16; // set this to your hardware output channel size, if necessary
    s.options.numInputBusChannels = 2; // set this to your hardware output channel size, if necessary

    s.waitForBoot {
        // 16 channel output
        ~dirt = SuperDirt(16, s);

        // MIDI instruments
        MIDIClient.init;
        ~midiOut = MIDIOut.newByName("UM-ONE", "UM-ONE MIDI 1");
        ~dirt.soundLibrary.addMIDI(\motor, ~midiOut);
        ~midiOut.latency = 0.04;

        // Samples
        // ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");

         // SuperDirt Voltage
        ("/home/slash/.config/SuperCollider/superdirt-voltage.scd").load;

        ~pitchNodes = ~pitchNodes ? IdentityDictionary.new;

        ~dirt.soundLibrary.addSynth(\persistentPitch, (
            play: {
                var out      = (~channel ? 0).asInteger;
                var n        = ~n ? 0;
                var port     = ~portamento ? 0.05;
                var steps    = ~stepsPerOctave ? 12;
                var offset   = ~offsetVolts ? 0;
                var curve    = ~curve ? 0;

                if (~pitchNodes[out].isNil or: { ~pitchNodes[out].isRunning.not }) {
                    ~pitchNodes[out] = Synth(\pitch, [
                        \out, out,
                        \n, n,
                        \stepsPerOctave, steps,
                        \offsetVolts, offset,
                        \portamento, port,
                        \curve, curve
                    ]);
                } {
                    s.sendBundle(s.latency, {
                        ~pitchNodes[out].set(
                            \n, n,
                            \stepsPerOctave, steps,
                            \offsetVolts, offset,
                            \portamento, port,
                            \curve, curve
                        );
                    });
                };
            }
        ));

        s.sync;
        ~dirt.start(57120, [0,2,4,6,8,10,12,14]);
    };

    s.latency = 1.5;
};
)
