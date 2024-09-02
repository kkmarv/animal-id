import cv2
from pyzbar import pyzbar
import sys

def decode_barcode(frame):
    # Scanne den Frame nach Barcodes
    barcodes = pyzbar.decode(frame)

    # Durchlaufe alle erkannten Barcodes
    for barcode in barcodes:
        # Barcode-Daten als Zeichenkette konvertieren
        barcode_data = barcode.data.decode('utf-8')
        return barcode_data

    return None

def capture_camera():
    # Öffne die Standardkamera (ID 0)
    cap = cv2.VideoCapture(0)

    # Überprüfe, ob die Kamera erfolgreich geöffnet wurde
    if not cap.isOpened():
        print("Fehler: Kamera konnte nicht geöffnet werden.")
        return

    while True:
        ret, frame = cap.read()
        

        if not ret:
            print("Fehler: Frame konnte nicht gelesen werden.")
            break

        barcode_data = decode_barcode(frame)
        cv2.imshow('Kamera mit Barcode-Erkennung', frame)

        # Warten auf die Eingabe der 'q'-Taste zum Beenden
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

        if barcode_data:
            print(barcode_data)
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    capture_camera()
