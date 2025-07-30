"""
DO NOT USE, IT'S NOT READY. JUST TESTING
"""

import argparse
import os
import subprocess

ROOT_DIRS = ["sound/rcsm", "sound/warthunder"]

def apply_ffmpeg_effects(in_path, out_path, effects, fade_duration, dry_run=False):
    filters = []

    if "normalize" in effects:
        filters.append("loudnorm=I=-16:LRA=11:TP=-1.5")

    if "cracks" in effects or fade_duration > 0:
        duration = fade_duration / 1000
        filters.append(f"afade=t=in:st=0:d={duration}")
        filters.append(f"afade=t=out:st=0:d={duration}")

    if "noise" in effects:
        print("  • Note: 'noise' removal not implemented via ffmpeg.")

    if "reduce_badhz" in effects:
        filters.append("highpass=f=40")
        filters.append("lowpass=f=16000")

    filter_str = ",".join(filters)
    cmd = ["ffmpeg", "-y", "-i", in_path]

    if filter_str:
        cmd += ["-af", filter_str]

    # 🛠️ Указываем вывод явно
    cmd += [
        "-acodec", "pcm_s16le",  # формат WAV
        "-ar", "44100",          # частота дискретизации
        "-ac", "1",              # 1 канал (моно)
        out_path
    ]

    if dry_run:
        print("[DRY]", " ".join(cmd))
        return

    try:
        subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        print(f"[+] {in_path} → {out_path}")
    except subprocess.CalledProcessError as e:
        print(f"[-] Failed: {in_path} → {out_path} ({e})")

def collect_input_sounds(inputF: str):
    parts = inputF.split("/")

    if len(parts) < 3:
        print("Bad argument")
        return []

    folder = parts[0]
    zone = parts[1]
    snd = parts[2]
    whole_folder = snd == "*"

    if not whole_folder and not snd.endswith(".wav"):
        print("bad sound argument. It should be .wav file!")
        return []

    search_folder = os.path.join(folder, zone)

    if not whole_folder:
        for root_dir in ROOT_DIRS:
            full_path = os.path.join(root_dir, search_folder, snd).replace("\\", "/")
            if os.path.isfile(full_path):
                return [full_path]
        return []

    results = []
    for root_dir in ROOT_DIRS:
        full_search = os.path.join(root_dir, search_folder)
        for root, _, files in os.walk(full_search):
            for file in files:
                if not file.lower().endswith(".wav"):
                    continue
                rel_path = os.path.join(root, file).replace("\\", "/")
                results.append(rel_path)

    return results

def collect_all_sounds():
    results = []
    for root_dir in ROOT_DIRS:
        for root, _, files in os.walk(root_dir):
            for file in files:
                if not file.lower().endswith(".wav"):
                    continue
                full_path = os.path.join(root, file).replace("\\", "/")
                results.append(full_path)
    return results

def parse_args():
    parser = argparse.ArgumentParser(description="RLFX Audio Cleaner Tool (FFmpeg)")
    parser.add_argument("--input", help="Input in format <ammotype>/<zone>/<file.wav or *>")
    parser.add_argument("--output", help="Output base folder (default: cleaned_sounds)")
    parser.add_argument("--clear", default="normalize,cracks", help="Comma-separated effects: normalize, cracks, noise, reduce_badhz")
    parser.add_argument("--fade", type=int, default=10, help="Fade duration in ms")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--replace", action="store_true")
    return parser.parse_args()

def main():
    args = parse_args()
    inputF = args.input
    effects = [e.strip().lower() for e in args.clear.split(",")]
    fade_duration = args.fade
    dry_run = args.dry_run
    replace = args.replace
    base_output = None if replace else (args.output or "cleaned_sounds")

    sounds_to_process = collect_all_sounds() if not inputF else collect_input_sounds(inputF)

    if not sounds_to_process:
        print("No valid .wav files found.")
        return

    for file in sounds_to_process:
        rel_path = file.replace("\\", "/")
        if rel_path.startswith("sound/"):
            rel_path = rel_path[6:]

        out_path = file if replace else os.path.join(base_output, rel_path)
        os.makedirs(os.path.dirname(out_path), exist_ok=True)

        apply_ffmpeg_effects(file, out_path, effects, fade_duration, dry_run=dry_run)

if __name__ == "__main__":
    main()
