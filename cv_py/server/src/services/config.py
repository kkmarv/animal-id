import json


MANIFEST = json.load(open("/etc/app/manifest.json", "r"))


class Config:
    def __init__(self, section) -> None:
        self.config = json.load(
            open("/etc/app/"+MANIFEST[section], "r")
        )
    def get(self, key):
        return self.config.get(key)
        