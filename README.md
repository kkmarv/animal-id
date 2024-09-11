# Animal ID

This project is a short demo and proof of concept for reducing bureaucracy in cattle registration in Germany.

It is the result of our participation in the [2024 BLE Hackathon](https://www.ble.de/DE/Projektfoerderung/Foerderungen-Auftraege/Digitalisierung/Veranstaltungen/EF-Konferenz_2024/Hackathon.html) in Berlin.
Our topic was "Overcoming bureaucracy in agriculture - Digitizing documentation obligations for more time in the barn"

We propose **Animal ID**, a general approach on digitizing analogue cattle registration and management for any kind of farm animal.
Our goal was to greatly reduce human involvement in the process and therefore the overhead of bureaucracy involved.

With Animal ID, a farmer is able to:

- Create animal registrations from a mobile device, as soon as an eartag is applied.
- Scan the barcode of an eartag from the app to prefill registration forms
- Register newborn cattle with a government authority
- Get an overview of their registered livestock from the app
- Lean back as there are no other steps required to register a newborn animal

Also, what could be possible in the future:

- Trade livestock from inside the app
- Integrate with governmental disease monitoring

Behind the scenes, Animal ID uses the concept of [Self Sovereign Identity](https://en.wikipedia.org/wiki/Self-sovereign_identity) so that everything a farmer does in Animal ID is **anonymous**, **cryptographically secure** and **traceable**.

## Get up and Running

To get a working demo, you'll need to:

1. [Deploy the IOTA wallet and VC issuer service](#start-the-rest-server)
2. [Run the App](#run-the-app)

## Frontend

TODO short description what it is

### Run the App

TODO short list of steps on how to get it running

## Barcode Scanner

TODO short description what it is

## IOTA Wallet & VC Issuer Service

This package lets us create, update and delete DIDs and communicate with the IOTA network for decentralized identity management.
It's also used to issue `AnimalIDCredentials`, our proposal for digital animal certificates and farm management.

For simplicity, we combined the user's personal IOTA wallet and a simple VC issuer into a single HTTP REST server.
In the real world, these would reside on completely different hosts. The user would install a wallet onto a personal device (e.g. smartphone) and the VC issuance service could for example be hosted by a government department.

### Start the REST Server

First, you'll need to [download Node.js](https://nodejs.org/en/download/package-manager) v20.17.0.

```shell
cd ssi
npm i
npm start
```
