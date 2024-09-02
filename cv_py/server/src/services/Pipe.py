import os
import json
from threading import Thread

def log(msg):
    with open("out", "a") as file:
        file.write(msg+"\n")


class PipeDirWatcher:
    def __init__(self, path):
        self.path = path
        self.callbacks = []
    def register_callback(self,callback):
        log("registering callback")
        self.callbacks.append(callback)
        return self
    def run(self):
        log("running as watcher")
        log("path is "+self.path)
        last_state = os.listdir(self.path)
        log("initial_state: "+json.dumps(last_state))
        while True:
            dif = [x for x in os.listdir(self.path) if x not in last_state]
            if(len(dif)!=0):
                log("dif called" + json.dumps(dif))
                last_state = os.listdir(self.path)
                for callback in self.callbacks:
                    for pipe in dif:
                        log("starting callback with path: "+ self.path+"/"+pipe)
                        callback(Pipe(self.path+"/"+pipe, "rw"))

        

class Pipe:
    def __init__(self, path, mode):
        try:
            os.mkfifo(path)
        except FileExistsError:
            pass
        if (mode == "r"):
            os_flags = os.O_NONBLOCK | os.O_RDONLY
        if (mode == "w"):
            os_flags = os.O_NONBLOCK | os.O_WRONLY
        if (mode == "rw"):
            os_flags = os.O_NONBLOCK | os.O_RDWR
        self.path = path
        self.name = path.split("/")[-1]
        self.file=os.open(path, os_flags)
    def write(self, data):
        if (type(data) in [str, int, float]):
            data = data.encode()
        os.write(self.file, data)
    def read_blocking(self, length = 1):
        data = b''
        while len(data) == 0:
            try:
                data = os.read(self.file, length)
            except BlockingIOError:
                pass
        return data

    def get_path(self):
        return self.path
    def get_name(self):
        return self.name