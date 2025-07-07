#!/bin/bash

# Usage: ./split_by_transients.sh input.wav [output_prefix]
input="$1"
prefix="${2:-hit_}"

if [[ -z "$input" ]]; then
  echo "Usage: $0 input.wav [output_prefix]"
  exit 1
fi

# Get onsets as array, one per line
mapfile -t onsets < <(aubio onset -O hfc -s -60 -B 512 -H 256  "$input")

# Get total duration
duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input")

# Add 0 at the start and duration at the end
onsets=(0 "${onsets[@]}" "$duration")

# Debug: print all onsets
echo "Onsets: ${onsets[@]}"

# Slice audio between onsets
for ((i=0; i<${#onsets[@]}-1; i++)); do
  start="${onsets[$i]}"
  end="${onsets[$((i+1))]}"
  len=$(awk "BEGIN {print $end - $start}")
  # Only export if duration is > 0.01s
  if (( $(awk "BEGIN {print ($len > 0.01)}") )); then
    echo "Exporting: start=$start, len=$len, file=${prefix}${i}.wav"
    ffmpeg -y -hide_banner -loglevel error -i "$input" -ss "$start" -t "$len" "${prefix}${i}.wav"
  fi
done

echo "Exported slices."
