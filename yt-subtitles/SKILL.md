---
name: yp-yt-subtitles
description: This skill should be used when users want to convert an MP3 file into a precisely chunked subtitle format with timestamps. It leverages Python and OpenAI's Whisper package to generate continuous SRT files with text limits (4-10 words) and organizes files in an `srt` folder within the skill's directory.
license: MIT
---

# Yp Yt Subtitles

## Overview

This skill allows you to quickly generate an SRT subtitle transcript (with continuous timestamps and precisely 4-10 words per subtitle) from an MP3 audio file. It automatically organizes the output by placing both the resulting SRT file and a copy of the MP3 file into a dedicated `srt` folder strictly located within the skill directory itself. 

## When to Use This Skill

Use this skill when:
- Creating transcripts for recorded lectures, podcasts, or YouTube videos.
- Converting audio into subtitles with exact timestamp synchronization.
- Generating SRT files for video editing purposes.

## Requirements

You must have Python 3 and the `openai-whisper` package installed, alongside `ffmpeg` which is required for Whisper.

```bash
# Install whisper and related dependencies using pip
pip install -U openai-whisper

# You will also need ffmpeg. On Mac, use Homebrew:
brew install ffmpeg
```

## Quick Start

You can transcribe an MP3 file using the provided Python scripts:

```bash
python3 scripts/transcribe_mp3.py "path_to_audio_file.mp3"
```

**Example:**
```bash
python3 scripts/transcribe_mp3.py "my_youtube_audio.mp3"
```

### What this will do:
1. Predicts word-level timestamps using Python's `whisper` package API.
2. Segments sentences automatically ensuring strictly 4 to 10 words per text block.
3. Overwrites and chains timestamps so they are flawlessly continuous.
4. Locates or creates the `srt` default folder physically inside the `yp-yt-subtitles` skill directory regardless of where the command is initially executed.
5. Copies the audio file along with generating the `.srt` in this centralized skill directory.

## Resources

### scripts/
- **transcribe_mp3.py**: Takes an MP3 file as an argument and handles the transcription and file organization perfectly.
