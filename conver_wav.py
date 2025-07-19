"""

WARNING THIS CODE NEED FFMPEG INSTALLED AND ADDED TO USER/SYSTEM PATH (IN WINDOWS)

DOWNLOAD PAGE: https://ffmpeg.org/download.html
WINDOWS guan.dev build: https://www.gyan.dev/ffmpeg/builds/

THIS SCRIPT CONVERTS SOUNDS TO GMOD BALANCED AND SUPPORTED FORMAT

"""
import os
import subprocess
import argparse
import shutil
import platform

SOUND_ROOTS = ["sound/rcsm", "sound/warthunder"] # target folders
TARGET_RATE = 22050
converted = 0
total = 0

def get_audio_params(path):
    result = subprocess.run([
        "ffprobe", "-v", "error", "-select_streams", "a:0",
        "-show_entries", "stream=sample_rate,channels,sample_fmt",
        "-of", "default=noprint_wrappers=1:nokey=1",
        path
    ], stdout=subprocess.PIPE)
    return result.stdout.decode().splitlines()

def is_correct_format(path):
    try:
        rate, channels, fmt = get_audio_params(path)
        return int(rate) == 22050 and int(channels) == 1 and fmt == "s16"
    except:
        return False

def convert_wav(src_path, dst_path):
    global converted

    if is_correct_format(src_path):
        print(f"[SKIP] Already correct format: {src_path}")
        return

    dst_dir = os.path.dirname(dst_path)
    os.makedirs(dst_dir, exist_ok=True)

    print(f"[CONVERT] {src_path} -> {dst_path}")
    result = subprocess.run([
        "ffmpeg", "-y",
        "-i", src_path,
        "-ar", str(TARGET_RATE),     # Sample Rate (Hz)
        "-ac", "1",                  # Mono
        "-sample_fmt", "s16",        # 16-bit PCM
        "-f", "wav",                 # WAV format
        "-af", "loudnorm",
        dst_path
    ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    if result.returncode == 0:
        converted += 1
    else:
        print(f"[ERROR] Не удалось конвертировать: {src_path}")
        print(result.stderr.decode())

def process_directory(src_root, dst_root):
    global total
    for dirpath, _, filenames in os.walk(src_root):
        for file in filenames:
            if file.lower().endswith(".wav"):
                total += 1
                rel_path = os.path.relpath(os.path.join(dirpath, file), src_root)
                dst_path = os.path.join(dst_root, rel_path)
                convert_wav(os.path.join(dirpath, file), dst_path)

def open_explorer(path):
    system = platform.system()
    if system == "Windows":
        os.startfile(os.path.abspath(path))
    elif system == "Darwin":
        subprocess.run(["open", path])
    else:
        subprocess.run(["xdg-open", path])

def main():
    parser = argparse.ArgumentParser(description="Конвертация WAV в 22050Hz/mono")
    parser.add_argument("--clean", action="store_true", help="Cleans output folder before start")

    args = parser.parse_args()
    dst_root = "builded_sounds"
    
    if args.clean and os.path.exists(dst_root):
        shutil.rmtree(dst_root)
    os.makedirs(dst_root, exist_ok=True)

    for src_root in SOUND_ROOTS:
        print(f"\n[SCAN] {src_root}")
        process_directory(src_root, os.path.join(dst_root, os.path.basename(src_root)))

    print(f"\nReady. Total: {total} files. Converted: {converted} to {TARGET_RATE} Hz, mono.")
    print(f"[Opening explorer]: {os.path.abspath(dst_root)}")
    open_explorer(dst_root)

if __name__ == "__main__":
    main()
