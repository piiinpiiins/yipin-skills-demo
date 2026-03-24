#!/usr/bin/env python3
"""
Download YouTube video as MP3 audio file.
使用 yt-dlp 下載 YouTube 影片並轉換為 MP3 格式。
"""

import sys
import os
import subprocess
from pathlib import Path

def get_video_id(url):
    """Extract video ID from YouTube URL."""
    if 'youtube.com/watch?v=' in url:
        return url.split('watch?v=')[1].split('&')[0]
    elif 'youtu.be/' in url:
        return url.split('youtu.be/')[1].split('?')[0]
    else:
        return url

def download_mp3(video_url, output_dir="youtube-mp3"):
    """
    Download YouTube video as MP3.

    Args:
        video_url: YouTube video URL or video ID
        output_dir: Directory to save MP3 file (default: youtube-mp3)

    Returns:
        Path to downloaded MP3 file if successful, None otherwise
    """
    try:
        video_id = get_video_id(video_url)
        print(f"📥 Downloading MP3 for video ID: {video_id}")

        # Create output directory if it doesn't exist
        Path(output_dir).mkdir(parents=True, exist_ok=True)

        # Build output template
        output_template = os.path.join(output_dir, "%(title)s.%(ext)s")

        # Build yt-dlp command
        cmd = [
            'yt-dlp',
            '-x',  # Extract audio only
            '--audio-format', 'mp3',  # Convert to MP3
            '--audio-quality', '0',  # Best quality
            '--output', output_template,
            '--no-playlist',  # Only download single video
            video_url
        ]

        print(f"⚙️  Converting to MP3...")
        result = subprocess.run(cmd, capture_output=True, text=True)

        if result.returncode != 0:
            print(f"❌ Error downloading: {result.stderr}")
            return None

        # Find the downloaded file
        mp3_files = list(Path(output_dir).glob("*.mp3"))
        if mp3_files:
            latest_file = max(mp3_files, key=lambda f: f.stat().st_mtime)
            file_size_mb = latest_file.stat().st_size / (1024 * 1024)
            print(f"✅ Downloaded: {latest_file.name}")
            print(f"📁 Location: {latest_file}")
            print(f"📊 Size: {file_size_mb:.1f} MB")
            return str(latest_file)
        else:
            print(f"❌ MP3 file not found after download")
            return None

    except subprocess.TimeoutExpired:
        print("❌ Download timeout")
        return None
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return None

def main():
    if len(sys.argv) < 2:
        print("YouTube to MP3 Downloader")
        print("=" * 40)
        print("\nUsage:")
        print("  python download_mp3.py <youtube_url> [output_directory]")
        print("\nExamples:")
        print("  python download_mp3.py https://www.youtube.com/watch?v=WREEYv36_2s")
        print("  python download_mp3.py https://youtu.be/WREEYv36_2s ./music")
        print("\nDefault output directory: youtube-mp3/")
        sys.exit(1)

    video_url = sys.argv[1]
    output_dir = sys.argv[2] if len(sys.argv) > 2 else "youtube-mp3"

    print(f"🎵 YouTube to MP3 Downloader")
    print(f"🔗 URL: {video_url}")
    print(f"📁 Output directory: {output_dir}")
    print("-" * 40)

    result = download_mp3(video_url, output_dir)

    if result:
        print("\n✅ Download completed successfully!")
    else:
        print("\n❌ Download failed")
        sys.exit(1)

if __name__ == "__main__":
    main()