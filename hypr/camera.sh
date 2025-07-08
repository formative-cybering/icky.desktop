ffplay -f v4l2 -i /dev/video0 -vf "rotate=PI,eq=contrast=2"
