"""
WARNING: THIS SCRIPT REQUIRES FFMPEG INSTALLED AND ADDED TO PATH.

DOWNLOAD: https://ffmpeg.org/download.html
Windows builds: https://www.gyan.dev/ffmpeg/builds/
"""

import os
import subprocess
import argparse
import shutil
import platform

ZONE_ORDER = ["close", "mid", "dist"]
SOUND_ROOTS = ["sound/rcsm", "sound/warthunder"]
TARGET_RATE = 22050
converted = 0
total = 0

def zone_sort_key(path):
    for i, zone in enumerate(ZONE_ORDER):
        if zone in path:
            return i
    return len(ZONE_ORDER)

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

def find_best_source(original_path, original_rel, dst_root):
    parts = original_rel.split(os.sep)
    parts_copy = parts.copy()

    zone_priority = ["close", "mid", "dist"]

    for zone in zone_priority:
        parts_copy[-2] = zone
        candidate_path = os.path.join(dst_root, *parts_copy)
        if os.path.exists(candidate_path):
            return candidate_path

    return original_path

def make_distance_variants(original_path, original_rel, dst_root):
    original_zone = os.path.dirname(original_rel).split(os.sep)[-1]
    if "_obstructed" in original_zone:
        print(f"[SKIP] Zone is already obstructed: {original_zone}")
        return

    base_parts = original_rel.split(os.sep)
    base_parts[-2] = "close"
    close_path = os.path.join(dst_root, *base_parts)

    if not os.path.exists(close_path):
        os.makedirs(os.path.dirname(close_path), exist_ok=True)
        print(f"[DISTANCE:CLOSE] {original_path} -> {close_path}")
        subprocess.run([
            "ffmpeg", "-y",
            "-i", original_path,
            "-af", "volume=4,highpass=f=60,aecho=0.8:0.9:100|180:0.3|0.25",
            "-ar", str(TARGET_RATE),
            "-ac", "1",
            "-sample_fmt", "s16",
            "-f", "wav",
            close_path
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    variants = {
        "mid":  "volume=1,lowpass=f=2000",
        "dist": "lowpass=f=1200,volume=1"
    }

    for variant, afilter in variants.items():
        base_parts[-2] = variant
        variant_path = os.path.join(dst_root, *base_parts)

        if os.path.exists(variant_path):
            continue

        os.makedirs(os.path.dirname(variant_path), exist_ok=True)
        print(f"[DISTANCE:{variant.upper()}] {close_path} -> {variant_path}")
        subprocess.run([
            "ffmpeg", "-y",
            "-i", close_path,
            "-af", afilter,
            "-ar", str(TARGET_RATE),
            "-ac", "1",
            "-sample_fmt", "s16",
            "-f", "wav",
            variant_path
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

def make_obstructed_version(original_path, original_rel, dst_root):
    parts = original_rel.split(os.sep)
    
    if "_obstructed" in parts[-2]:
        print(f"[SKIP] Уже obstructed: {original_rel}")
        return
    
    if parts[-2] in ["close", "mid"]:
        return
    
    if len(parts) >= 2:
        parts[-2] = parts[-2] + "_obstructed"
    else:
        print(f"[WARN] Невозможно определить зону для obstructed: {original_rel}")
        return

    obstructed_rel = os.path.join(*parts)
    obstructed_path = os.path.join(dst_root, obstructed_rel)
    os.makedirs(os.path.dirname(obstructed_path), exist_ok=True)

    if os.path.exists(obstructed_path):
        print(f"[SKIP] Уже существует obstructed: {obstructed_path}")
        return

    print(f"[OBSTRUCTED] {original_path} -> {obstructed_path}")
    result = subprocess.run([
        "ffmpeg", "-y",
        "-i", original_path,
        "-af", "lowpass=f=600,volume=0.85",
        "-ar", str(TARGET_RATE),
        "-ac", "1",
        "-sample_fmt", "s16",
        "-f", "wav",
        obstructed_path
    ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    if result.returncode != 0:
        print(f"[ERROR] Не удалось создать obstructed: {original_path}")
        print(result.stderr.decode())

def convert_wav(src_path, dst_path, rel_path, dst_root):
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
        "-ar", str(TARGET_RATE),
        "-ac", "1",
        "-sample_fmt", "s16",
        "-f", "wav",
        "-af", "loudnorm",
        dst_path
    ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    if result.returncode == 0:
        converted += 1
        make_obstructed_version(dst_path, rel_path, dst_root)
        make_distance_variants(dst_path, rel_path, dst_root)
    else:
        print(f"[ERROR] Не удалось конвертировать: {src_path}")
        print(result.stderr.decode())

def process_directory(src_root, dst_root, ammotype):
    global total
    for dirpath, dirnames, filenames in os.walk(src_root):
        if ammotype and ammotype not in dirpath:
            continue
        
        dirnames.sort(key=zone_sort_key)
        filenames.sort()
        
        for file in filenames:
            if file.lower().endswith(".wav"):
                total += 1
                rel_path = os.path.relpath(os.path.join(dirpath, file), src_root)
                dst_path = os.path.join(dst_root, rel_path)
                convert_wav(os.path.join(dirpath, file), dst_path, rel_path, dst_root)

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
    parser.add_argument("--clean", action="store_true", help="Удалить builded_sounds перед началом")
    parser.add_argument("--ammotype", type=str, help="Обрабатывать только конкретную подпапку (например: 25mm)")
    parser.add_argument("--open", type=str, help="Открывать дерикторию по завершению")
    args = parser.parse_args()

    dst_root = "builded_sounds"
    if args.clean and os.path.exists(dst_root):
        shutil.rmtree(dst_root)
    os.makedirs(dst_root, exist_ok=True)

    for src_root in SOUND_ROOTS:
        print(f"\n[SCAN] {src_root}")
        process_directory(src_root, os.path.join(dst_root, os.path.basename(src_root)), ammotype=args.ammotype)

    print(f"\nГотово. Всего файлов: {total}. Конвертировано: {converted} в {TARGET_RATE} Hz, mono.")
    print(f"[Открытие папки]: {os.path.abspath(dst_root)}")
    
    if args.open:
        open_explorer(dst_root)

if __name__ == "__main__":
    main()
