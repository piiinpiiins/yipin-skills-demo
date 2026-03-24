---
name: timelapse_4x_movie_generator
description: This skill processes video files to create 4x speed timelapse videos. It preserves the original aspect ratio, removes audio tracks, and outputs an MP4 file with timestamp-based naming. Use when users upload a video and want to create a fast-motion timelapse version.
---

# Timelapse 4x Movie Generator

## Overview

Processes uploaded video files to create 4x speed timelapse videos while preserving the original aspect ratio. The output is a silent MP4 file with automatic timestamp-based naming.

## Prerequisites

- **ffmpeg** must be installed on the system (`brew install ffmpeg` on macOS, or `apt-get install ffmpeg` on Linux)

## Workflow

### Step 1: Receive Video File

When the user uploads or provides a video file path, verify the file exists and is a valid video format (`.mp4`, `.mov`, `.avi`, `.mkv`, `.webm`, etc.).

### Step 2: Determine Output Directory

- Default output directory: the same directory as the input video file.
- If the user specifies a different output location, use that instead.

### Step 3: Execute the Processing Script

Run the bundled script to process the video:

```bash
bash <skill-directory>/scripts/process_timelapse.sh <input_video_path> [output_directory]
```

The script handles:
- Speeding up video to 4x speed (using setpts filter)
- Preserving original aspect ratio
- Removing all audio tracks
- Generating output filename as `yyyymmdd_HH_MM_SS.mp4` (current timestamp in 24-hour format)
- Encoding with H.264 (libx264) for maximum compatibility

### Step 4: Report Results

After the script completes, report to the user:
- The output file path
- Original video duration vs. new duration (1/4 of original)
- File size comparison (if available)

## Error Handling

- If ffmpeg is not installed, instruct the user to install it
- If the input video path is invalid, report the error
- If the output directory does not exist, the script creates it automatically
- If processing fails, display the ffmpeg error message

## Technical Details

### Video Processing Parameters

- **Speed**: 4x (setpts=0.25*PTS for video)
- **Audio**: Removed entirely (-an flag)
- **Aspect Ratio**: Preserved from original (no scaling or cropping)
- **Output Format**: MP4 with H.264 video codec
- **Naming Convention**: `yyyymmdd_HH_MM_SS.mp4` (e.g., `20260316_143055.mp4`)

### FFmpeg Command Example

```bash
ffmpeg -i input.mp4 -filter:v "setpts=0.25*PTS" -an -c:v libx264 -preset medium -crf 23 output.mp4
```

## Resources

### scripts/

- `process_timelapse.sh` — Bash script wrapping ffmpeg to create 4x timelapse videos. Execute directly without needing to read into context.
