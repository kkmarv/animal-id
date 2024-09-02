import subprocess
def capture_camera():
    return subprocess.Popen("python ../tesseract/Main.py -t ").stdout.read()