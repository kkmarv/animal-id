import { JwkMemStore, KeyIdMemStore, Storage } from "@iota/identity-wasm/node/index.js"
import { Utils } from '@iota/sdk-wasm/node/lib/index.js'

export const wallet = new Storage(new JwkMemStore(), new KeyIdMemStore())

// Generate a random mnemonic for our wallet.
export const mnemonic = {
  mnemonic: Utils.generateMnemonic(),
}
