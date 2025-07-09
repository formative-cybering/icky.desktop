# open webcam, rotate 180deg and make high contrast, used for synth capture
ffplay -f v4l2 -i /dev/video0 -vf "rotate=PI,eq=contrast=2"
