#!/usr/bin/env python3

import shutil
import subprocess
import os
import sys
import time

class TeslaDashcamManager(object):

    def __init__(self, staging_path, raw_storage_path, destination_path, tesla_dashcam, raw_storage_retain_days = 365):
        self.staging_path = staging_path
        self.processing_path = os.path.join(staging_path, "processing")
        self.raw_storage_path = raw_storage_path
        self.destination_path = destination_path
        self.tesla_dashcam = tesla_dashcam
        self.raw_storage_retain_days = raw_storage_retain_days

        self.monitor_path = self.staging_path + "/ARCHIVE_UPLOADED"

        self.tesla_dashcam_arguments = ["--title-screen-map", "--no-check_for_update"]

    def move_to_raw_storage(self, dir):
        try:
            shutil.move(dir, self.raw_storage_path)
        except:
            print(f"Can't move {dir} to {self.raw_storage_path}")

    def get_clips_from_staging(self):
        incoming = []
        if os.path.exists(self.monitor_path):
            os.unlink(self.monitor_path)

            for dirpath, dirnames, _ in os.walk(self.staging_path):
                if os.path(dirpath) == self.processing_path:
                    continue

                for dir in dirnames:
                    path = os.path.join(dirpath, dir)
                    files = os.listdir(path)
                    if "event.json" in files:
                        incoming.append(path)

            processing_paths = []
            for path in out:
                dst = os.path.join(self.processing_path, os.path.basename(path))
                try:
                    shutil.move(path, self.processing_path)
                    incoming.append(dst)
                except:
                    print(f"Can't move {path} to {self.self.processing_path}, skipping")

            return processing_paths

        return []

    def prune_old_clips(self):
        entries = os.listdir(self.raw_storage_path)

        # Keep forever
        if self.raw_storage_retain_days == 0:
            return

        now = time.time()
        for dir in entries:
            cur = os.path.join(self.raw_storage_path, dir)
            if not os.path.isdir(cur) or cur.startswith("."):
                continue
            stat = os.stat(cur)
            age_days = (now - stat.st_ctime) / (60*60*24)
            if age_days >= self.raw_storage_retain_days:
                print(f"{cur} is {age_days} old, would rmtree")


    def process_clip(self, clip_path):
        args = ["python3", self.tesla_dashcam] + self.tesla_dashcam_arguments + \
            ["--output", self.destination_path, clip_path]
        try:
            subprocess.run(args, capture_output=True, check=True)
        except subprocess.CalledProcessError as exc:
            print(f"Error when running tesla_dashcam: RC: {exc.returncode}\n"
                f"Command: {exc.cmd}\n"
                f"Error: {exc.stderr}\n")

    def get_and_process(self):
        clips = self.get_clips_from_staging()
        if len(clips) != 0:
            print(f"Processing {len(clips)} clips")
        for clip in clips:
            self.process_clip(clip)
            self.prune_old_clips()
            self.move_to_raw_storage(clip)


    def run(self):
        while True:
            self.get_and_process()
            time.sleep(2)


def usage():
    print(f"Usage: {__file__} <staging-path> <raw-storage-path> <destination-path> [tesla_dashcam.py-path] [retain-days-for-raw-storage]")
    sys.exit(1)

def verify_create_path(path):
    if not os.path.exists(path):
        try:
            os.makedirs(path)
        except:
            print(f"Can't create {path}")
            usage()

    if not os.path.isdir(path):
        print(f"{path} is not a directory")
        usage()

    return path

if __name__ == "__main__":
    if len(sys.argv) < 4:
        usage()

    staging_path = verify_create_path(sys.argv[1])
    raw_storage_path = verify_create_path(sys.argv[2])
    destination_path = verify_create_path(sys.argv[3])

    verify_create_path(os.path.join(staging_path, "processing"))

    tesla_dashcam = "/usr/bin/tesla_dashcam.py"
    raw_storage_retain_days = 0
    if len(sys.argv) >= 5:
        tesla_dashcam = sys.argv[4]
    if len(sys.argv) >= 6:
        raw_storage_retain_days = int(sys.argv[5])

    manager = TeslaDashcamManager(staging_path, raw_storage_path, destination_path, tesla_dashcam, raw_storage_retain_days)
    manager.run()
