// Copyright 2020-2023 IOTA Stiftung
// SPDX-License-Identifier: Apache-2.0
// 
// Changed by kkmarv:
// - Added mnemonic and wallet parameters to enable re-usability

import {
  IotaDocument,
  JwkMemStore,
  JwsAlgorithm,
  MethodScope
} from "@iota/identity-wasm/node/index.js"
import { SecretManager, Utils } from "@iota/sdk-wasm/node/lib/index.js"
import { didClient } from "./client.js"
import { ensureAddressHasFunds } from "./util.js"

/** Demonstrate how to create a DID Document and publish it in a new Alias Output. */
export async function createIdentity(mnemonic, wallet) {

  // Get the Bech32 human-readable part (HRP) of the network.
  const networkHrp = await didClient.getNetworkHrp()

  // Generate a random mnemonic for our wallet.
  const secretManager = new SecretManager(mnemonic)

  const walletAddressBech32 = (await secretManager.generateEd25519Addresses({
    accountIndex: 0,
    range: {
      start: 0,
      end: 1,
    },
    bech32Hrp: networkHrp,
  }))[0]
  console.log("Wallet address Bech32:", walletAddressBech32)

  // Request funds for the wallet, if needed - only works on development networks.
  await ensureAddressHasFunds(walletAddressBech32)

  // Create a new DID document with a placeholder DID.
  // The DID will be derived from the Alias Id of the Alias Output after publishing.
  const document = new IotaDocument(networkHrp)

  // Insert a new Ed25519 verification method in the DID document.
  await document.generateMethod(
    wallet,
    JwkMemStore.ed25519KeyType(),
    JwsAlgorithm.EdDSA,
    "#key-1",
    MethodScope.VerificationMethod(),
  )

  // Construct an Alias Output containing the DID document, with the wallet address
  // set as both the state controller and governor.
  const address = Utils.parseBech32Address(walletAddressBech32)
  const aliasOutput = await didClient.newDidOutput(address, document)
  console.log("Alias Output:", JSON.stringify(aliasOutput, null, 2))

  // Publish the Alias Output and get the published DID document.
  const published = await didClient.publishDidOutput(mnemonic, aliasOutput)
  console.log("Published DID document:", JSON.stringify(published, null, 2))

  return published.id()
}
