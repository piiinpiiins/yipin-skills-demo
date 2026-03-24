import sys
import os
import argparse
import whisper

def main():
    parser = argparse.ArgumentParser(description="Generate a verbatim transcript (逐字稿) from a video or audio file with multi-language support.")
    parser.add_argument("input_file", help="Path to the input video or audio file.")
    parser.add_argument("--model", default="turbo", help="Whisper model to use (default: turbo). Try 'base' or 'large-v3' if you lack resources.")
    args = parser.parse_args()

    input_file = args.input_file

    if not os.path.isfile(input_file):
        print(f"Error: Could not find file '{input_file}'")
        sys.exit(1)

    # 4. 存檔名與原始 video or audio 的檔名一樣
    # Get the original filename without the directory path
    original_filename = os.path.basename(input_file)
    file_base, _ = os.path.splitext(original_filename)

    # 5. 放入 transcription folder
    # Find the skill directory (which is the parent of the currently executing script's parent folder)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    skill_dir = os.path.dirname(script_dir)
    transcription_folder = os.path.join(skill_dir, "transcription")

    # Create the folder if it doesn't exist
    os.makedirs(transcription_folder, exist_ok=True)

    # Path to save the extracted text
    output_filepath = os.path.join(transcription_folder, f"{file_base}.txt")

    print(f"Loading Whisper model: {args.model}...")
    try:
        model = whisper.load_model(args.model)
    except Exception as e:
        print(f"Failed to load the '{args.model}' model. It may not be available or requires an update:")
        print(e)
        print("Falling back to 'base' model...")
        model = whisper.load_model("base")

    # 3. 此音檔可能有多種語言，需要多語言判斷能力
    # Whisper automatically detects languages if no explicit language argument is provided.
    print(f"Transcribing '{input_file}' and auto-detecting language...")
    
    # Run whisper to transcribe
    result = model.transcribe(input_file)
    
    detected_lang = result.get("language", "unknown")
    print(f"Detected language: {detected_lang}")

    # 2. 產生一個逐字稿 (verbatim transcript) 並且段落分明
    segments = result.get("segments", [])
    transcript_lines = []
    for segment in segments:
        text = segment["text"].strip()
        if text:
            transcript_lines.append(text)
    
    # 每個段落用雙換行分隔，達到「段落分明」的效果
    transcript_text = "\n\n".join(transcript_lines)

    # Save to the transcription folder
    print(f"Saving transcript to: {output_filepath}")
    with open(output_filepath, "w", encoding="utf-8") as f:
        f.write(transcript_text)

    print("Success! Transcript generation completed.")

if __name__ == "__main__":
    main()
