---
name: yp-youtube-mp3-downloader
description: This skill should be used when users want to download audio from YouTube videos as MP3 files. It uses yt-dlp to extract and convert YouTube video audio to high-quality MP3 format, saving files to a designated folder.
license: MIT
---

# YouTube to MP3 Downloader

## Overview

This skill enables quick and easy downloading of YouTube videos as MP3 audio files. It uses yt-dlp to extract audio and convert it to high-quality MP3 format.

## When to Use This Skill

Use this skill when:
- Downloading audio from YouTube videos for offline listening
- Extracting audio content from video tutorials or lectures
- Converting YouTube music videos to MP3 format
- Saving podcast episodes that are hosted on YouTube

## Quick Start

To download a YouTube video as MP3:

```bash
python3 scripts/download_mp3.py <youtube_url>
```

**Example:**
```bash
python3 scripts/download_mp3.py "https://www.youtube.com/watch?v=WREEYv36_2s"
```

The MP3 file will be saved in the `youtube-mp3/` folder with the video title as the filename.

## Installation Requirements

### Step 1: Install yt-dlp

```bash
# macOS (using Homebrew)
brew install yt-dlp

# or using pip
pip3 install yt-dlp
```

### Step 2: Install ffmpeg (required for audio conversion)

```bash
# macOS
brew install ffmpeg

# Ubuntu/Debian
sudo apt-get install ffmpeg
```

## Usage

### Basic Usage

Download a single video as MP3:

```bash
python3 scripts/download_mp3.py "https://www.youtube.com/watch?v=VIDEO_ID"
```

### Specify Output Directory

Save MP3 to a custom directory:

```bash
python3 scripts/download_mp3.py "https://www.youtube.com/watch?v=VIDEO_ID" ./my-music
```

### Command Line Options

The script accepts the following arguments:
- **video_url** (required): YouTube video URL or video ID
- **output_directory** (optional): Directory to save MP3 files (default: `youtube-mp3/`)

## Features

- 🎵 **High-Quality Audio**: Downloads at the best available audio quality
- 📁 **Organized Storage**: Automatically saves to `youtube-mp3/` folder
- 📝 **Descriptive Filenames**: Uses video title as filename
- ⚡ **Fast Processing**: Efficient download and conversion
- 🔄 **Format Conversion**: Automatically converts to MP3 format

## Output

Downloaded MP3 files are saved with the following characteristics:
- **Location**: `youtube-mp3/` folder (or custom directory if specified)
- **Filename**: Original video title with `.mp3` extension
- **Quality**: Best available audio quality from the source
- **Format**: MP3 (universally compatible)

## Troubleshooting

### yt-dlp Not Found

If you get "command not found" error:
```bash
# Install yt-dlp
pip3 install --upgrade yt-dlp
```

### ffmpeg Not Found

If conversion fails with ffmpeg error:
```bash
# Install ffmpeg (macOS)
brew install ffmpeg
```

### Download Fails

If download fails, try updating yt-dlp:
```bash
pip3 install --upgrade yt-dlp
```

### JavaScript Challenge Error

If you encounter JavaScript challenge errors with newer videos:
```bash
# Install deno (JavaScript runtime)
brew install deno

# Run with remote components
yt-dlp --remote-components ejs:github -x --audio-format mp3 "VIDEO_URL"
```

### Private Video Access

For private videos you have access to:
```bash
# Use browser cookies
yt-dlp --cookies-from-browser chrome -x --audio-format mp3 "VIDEO_URL"
```

## Alternative Direct Command

You can also use yt-dlp directly without the Python script:

```bash
# Basic download
yt-dlp -x --audio-format mp3 -o "youtube-mp3/%(title)s.%(ext)s" "VIDEO_URL"

# With browser cookies (for private videos)
yt-dlp --cookies-from-browser chrome -x --audio-format mp3 -o "youtube-mp3/%(title)s.%(ext)s" "VIDEO_URL"
```

## Resources

### scripts/

- **download_mp3.py**: Main script for downloading YouTube videos as MP3 files

### youtube-mp3/

- Default output directory for downloaded MP3 files
- Created automatically when downloading