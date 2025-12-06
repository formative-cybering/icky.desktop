#!/bin/bash

# Configuration
OUTPUT_DIR="$HOME/Videos"
AUDIO_SOURCE="alsa_input.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo"
BITRATE="8M"
FRAMERATE="30"
NICE_VALUE="0"

# Ensure dependencies
command -v wf-recorder >/dev/null 2>&1 || { notify-send -u critical "Error: wf-recorder not installed"; exit 1; }
command -v slurp >/dev/null 2>&1 || { notify-send -u critical "Error: slurp not installed"; exit 1; }
command -v hyprctl >/dev/null 2>&1 || { notify-send -u critical "Error: hyprctl not installed"; exit 1; }
command -v jq >/dev/null 2>&1 || { notify-send -u critical "Error: jq not installed"; exit 1; }
command -v notify-send >/dev/null 2>&1 || { echo "Warning: notify-send not installed"; }

# Check if wf-recorder is running
if pgrep -x "wf-recorder" >/dev/null; then
    pkill -INT -x wf-recorder
    notify-send -h string:wf-recorder:record -t 2000 "Recording Stopped"
    exit 0
fi

# Generate timestamp
dateTime=$(date +%m-%d-%Y-%H_%M_%S)

# Check audio source
if ! pactl list sources | grep -q "$AUDIO_SOURCE"; then
    notify-send -u critical "Error: Audio source $AUDIO_SOURCE not found"
    exit 1
fi

# Get region geometry
if [ "$1" = "window" ]; then
    ACTIVE=$(hyprctl activewindow -j)
    if [ "$ACTIVE" = "null" ]; then
        notify-send -u critical "No active window"
        exit 1
    fi
    x=$(echo "$ACTIVE" | jq -r '.at[0]')
    y=$(echo "$ACTIVE" | jq -r '.at[1]')
    w=$(echo "$ACTIVE" | jq -r '.size[0]')
    h=$(echo "$ACTIVE" | jq -r '.size[1]')
    GEOMETRY="$x,$y ${w}x${h}"
else
    GEOMETRY=$(slurp) || { notify-send -u critical "Error: Region selection canceled"; exit 1; }
fi

# Start recording (selected region)
nice -n "$NICE_VALUE" wf-recorder -g "$GEOMETRY" --audio="$AUDIO_SOURCE" --ffmpeg-opts="vcodec=h264_nvenc,preset=p1,rc=vbr,rc-lookahead=0,bframes=0,bit_rate=$BITRATE,ar=48000" -r "$FRAMERATE" -f "$OUTPUT_DIR/$dateTime.mp4" 2> /tmp/wf-recorder-error.log &

# Show notification
notify-send -h string:wf-recorder:record -t 2000 "Recording Started" "Saving to $OUTPUT_DIR/$dateTime.mp4" || echo "Recording started: $OUTPUT_DIR/$dateTime.mp4"
