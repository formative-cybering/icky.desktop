(
s.reboot {
    s.options.numBuffers = 1024 * 256; // increase this if you need to load more samples
    s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
    s.options.numWireBufs = 64; // increase this if you get "exceeded number of interconnect buffers" messages
    s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
    s.options.numOutputBusChannels = 16; // set this to your hardware output channel size, if necessary
    s.options.numInputBusChannels = 2; // set this to your hardware output channel size, if necessary

    s.waitForBoot {
      ~dirt = SuperDirt(16, s);
      //
      MIDIClient.init;
      ~midiOut = MIDIOut.newByName("UM-ONE", "UM-ONE MIDI 1");
      ~dirt.soundLibrary.addMIDI(\mi, ~midiOut);
      ~midiOut.latency = 0.04;
      //
      ("/home/slash/.config/SuperCollider/superdirt-voltage.scd").load;
      //
      // ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");
      //
      s.sync;
      //
      ~dirt.start(57120, [0,2,4,6,8,10,12,14]);
    };

    s.latency = 0.0;
};
);
