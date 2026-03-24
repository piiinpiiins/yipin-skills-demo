---
name: yp-yt-transcription
description: A skill to generate verbatim transcripts from audio or video files with robust multi-language detection.
license: MIT
---

# yp-yt-transcription

## Overview

This skill allows you to quickly generate a complete verbatim transcript (逐字稿) from any supported video or audio file. It utilizes OpenAI's [Whisper](https://github.com/openai/whisper) model, which automatically detects the language of the audio file (supporting multiple languages including English, Chinese, Japanese, etc.) and produces an accurate transcription.

The generated transcription is saved as a `.txt` file with the exact same base name as the original audio/video file, and is placed in the `transcription` folder inside the skill directory.

## Features

1. **Audio & Video Support**: Accepts video or audio file formats supported by ffmpeg (e.g., `.mp4`, `.mp3`, `.wav`, `.m4a`).
2. **Multi-language Detection**: Automatically identifies the spoken language and accurately transcribes the speech.
3. **Structured Storage**: The output file is named identically to the source media (with a `.txt` extension) and is saved directly into a dedicated `transcription` folder to keep your workspace organized.

## Requirements

Ensure you have Python 3, `openai-whisper`, and `ffmpeg` installed.

```bash
# Install whisper framework
pip install -U openai-whisper

# You will also need ffmpeg. On Mac, use Homebrew:
brew install ffmpeg
```

## Quick Start

You can transcribe any media file using the provided Python script:

```bash
python3 scripts/transcribe.py "path_to_audio_or_video_file.mp4"
```

### What this will do:
1. Loads the Whisper model.
2. Analyzes the audio/video to auto-detect the spoken language.
3. Generates a plain text verbatim transcription.
4. Creates the `transcription` directory (if it doesn't already exist) right inside the `yp-yt-transcription` skill directory.
5. Saves the text transcript with the same name as the original file inside the `transcription` directory.

## Resources

### scripts/
- **transcribe.py**: The main Python script that handles model loading, multi-language detection, transcription generation, and file saving.
