import subprocess
def capture_camera():
    return subprocess.Popen("python /opt/app/tesseract/Main.py -t ").stdout.read()