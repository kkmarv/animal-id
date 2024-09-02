from .services.config import Config
from .services.Pipe import PipeDirWatcher
from .services.Vision import BarcodeScanner, TextSearcher
from threading import Thread
import json
import sys
import os

def log(msg):
    with open("out", "a") as file:
        file.write(msg+"\n")

def worker(pipe):
    log("running as worker")
    inp = pipe.read_blocking()
    log("finished first reading as worker")
    while True:
        try:
            cmd = json.loads(inp.decode())
            break
        except:
            pass
        inp+=pipe.read_blocking()
    log("received cmd: "+ json.dumps(cmd))
    if (cmd['cmd'] == "start_search_barcode_dialoge"):
        print(BarcodeScanner.capture_camera(), file=pipe)
    elif cmd['cmd'] == "start_search_text_dialoge":
        pipe.write(TextSearcher.capture_camera())


def dispatch_worker(pipe):
    Thread(target=worker, args=[pipe]).run()
    log("dispatched")
    



def setup():
    with open("out", "w") as file:
        file.write("")
    path_config = Config("paths")
    os.system(f"rm {path_config['pipes']}/*")

def main():
    path_config = Config("paths")

    watcher = PipeDirWatcher(path_config.get("pipes")).register_callback(dispatch_worker)
    log("running watcher")
    watcher.run()