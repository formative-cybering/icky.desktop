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

        // Cut groups for pitch cutting
        ~cutGroups = IdentityDictionary.new;

        // MIDI instruments
        MIDIClient.init;
        ~midiOut = MIDIOut.newByName("UM-ONE", "UM-ONE MIDI 1");
        ~dirt.soundLibrary.addMIDI(\motor, ~midiOut);
        ~midiOut.latency = 0.04;

        // Samples
        // ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");

         // SuperDirt Voltage
        ("/home/slash/.config/SuperCollider/superdirt-voltage.scd").load;

        // new pitch synth
        // set your channels for pitch synths here
        ~pitchChannels = [1, 2];

        SynthDef(\persistentPitch, {
          | out,
          channel = 0,
          freq = 220,
          portamento = 0 |
          var n = Lag.ar(log2(K2A.ar(freq)/440), portamento);
          var sig = LinLin.ar(n, -1, 9, 0, 1);
          OffsetOut.ar(channel, [sig]);
        }).add;

       ~cv_ndefs = ~pitchChannels.collect { |i|
           var channel = ~pitchChannels[i];
           var name = (\cv_np ++ channel).asSymbol;
           Ndef(name).source = \persistentPitch;
           Ndef(name).set(\channel, channel);
           Ndef(name);
       };

       ~pitchChannels.do { |i|
            var channel = ~pitchChannels[i];
            var name = (\p ++ channel).asSymbol;
            var cv = (\cv_np ++ channel).asSymbol;
           ~dirt.soundLibrary.addSynth((name).asSymbol, (play: {
               var latency = (~latency ? 0);
               var freq = ~freq;
               var portamento = ~portamento;
               var ndef = Ndef(cv).wakeUp;
               ndef.wakeUp;
               // schedule the cycles, prevents delayed signals
               thisThread.clock.sched(latency - 0.025, {
                   ndef.set(\portamento, portamento);
                   ndef.set(\channel, channel);
                   ndef.set(\freq, freq);
               });
           }));
       };

        s.sync;

        ~dirt.start(57120, [0,2,4,6,8,10,12,14]);

    };

    s.latency = 0.1;
};
)
