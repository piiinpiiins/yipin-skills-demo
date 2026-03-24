#!/bin/bash

# Timelapse 4x Movie Generator Script
# Creates a 4x speed timelapse video with no audio and timestamp-based naming

set -e

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is not installed."
    echo "Please install it using: brew install ffmpeg (macOS) or apt-get install ffmpeg (Linux)"
    exit 1
fi

# Check arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 <input_video_path> [output_directory]"
    echo ""
    echo "Arguments:"
    echo "  input_video_path    - Path to the input video file"
    echo "  output_directory    - (Optional) Directory to save the output. Defaults to input video's directory"
    exit 1
fi

INPUT_VIDEO="$1"

# Check if input file exists
if [ ! -f "$INPUT_VIDEO" ]; then
    echo "Error: Input video file not found: $INPUT_VIDEO"
    exit 1
fi

# Determine output directory
if [ $# -ge 2 ]; then
    OUTPUT_DIR="$2"
else
    OUTPUT_DIR="$(dirname "$INPUT_VIDEO")"
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Generate timestamp-based filename (yyyymmdd_HH_MM_SS)
TIMESTAMP=$(date +"%Y%m%d_%H_%M_%S")
OUTPUT_FILE="${OUTPUT_DIR}/${TIMESTAMP}.mp4"

echo "========================================="
echo "Timelapse 4x Movie Generator"
echo "========================================="
echo "Input video:  $INPUT_VIDEO"
echo "Output file:  $OUTPUT_FILE"
echo "Speed:        4x"
echo "Audio:        Removed"
echo "========================================="
echo ""

# Get input video duration
echo "Analyzing input video..."
INPUT_DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$INPUT_VIDEO" 2>/dev/null || echo "unknown")

if [ "$INPUT_DURATION" != "unknown" ]; then
    OUTPUT_DURATION=$(echo "$INPUT_DURATION / 4" | bc -l)
    printf "Original duration: %.2f seconds\n" "$INPUT_DURATION"
    printf "New duration:      %.2f seconds (4x speed)\n" "$OUTPUT_DURATION"
    echo ""
fi

# Process video with ffmpeg
echo "Processing video..."
ffmpeg -i "$INPUT_VIDEO" \
    -filter:v "setpts=0.25*PTS" \
    -an \
    -c:v libx264 \
    -preset medium \
    -crf 23 \
    -movflags +faststart \
    "$OUTPUT_FILE" \
    -y 2>&1 | grep -E "time=|frame=|speed=" || true

echo ""
echo "========================================="
echo "Processing complete!"
echo "========================================="
echo "Output saved to: $OUTPUT_FILE"

# Get output file size
if [ -f "$OUTPUT_FILE" ]; then
    INPUT_SIZE=$(du -h "$INPUT_VIDEO" | cut -f1)
    OUTPUT_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
    echo "Input file size:  $INPUT_SIZE"
    echo "Output file size: $OUTPUT_SIZE"
fi

echo "========================================="
