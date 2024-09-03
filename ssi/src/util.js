import {
  IotaDocument,
  JwkMemStore,
  JwsAlgorithm,
  MethodScope
} from "@iota/identity-wasm/node"
import {
  SecretManager,
  Utils
} from "@iota/sdk-wasm/node"
import { client, didClient } from "./client.js"

export const API_ENDPOINT = "https://api.testnet.shimmer.network"
export const FAUCET_ENDPOINT = "https://faucet.testnet.shimmer.network/api/enqueue"



/** Creates a DID Document and publishes it in a new Alias Output.

Its functionality is equivalent to the "create DID" example
and exists for convenient calling from the other examples. */
export async function createDid(secretManager, storage) {
  const networkHrp = await didClient.getNetworkHrp()

  const secretManagerInstance = new SecretManager(secretManager)
  const walletAddressBech32 = (await secretManagerInstance.generateEd25519Addresses({
    accountIndex: 0,
    range: {
      start: 0,
      end: 1,
    },
    bech32Hrp: networkHrp,
  }))[0]

  console.log("Wallet address Bech32:", walletAddressBech32)

  await ensureAddressHasFunds(walletAddressBech32)

  const address = Utils.parseBech32Address(walletAddressBech32)

  // Create a new DID document with a placeholder DID.
  // The DID will be derived from the Alias Id of the Alias Output after publishing.
  const document = new IotaDocument(networkHrp)

  const fragment = await document.generateMethod(
    storage,
    JwkMemStore.ed25519KeyType(),
    JwsAlgorithm.EdDSA,
    "#jwk",
    MethodScope.AssertionMethod(),
  )

  // Construct an Alias Output containing the DID document, with the wallet address
  // set as both the state controller and governor.
  const aliasOutput = await didClient.newDidOutput(address, document)

  // Publish the Alias Output and get the published DID document.
  const published = await didClient.publishDidOutput(secretManager, aliasOutput)

  return { address, document: published, fragment }
}

/** Request funds from the faucet API, if needed, and wait for them to show in the wallet. */
export async function ensureAddressHasFunds(addressBech32) {
  let balance = await getAddressBalance(addressBech32)
  if (balance > BigInt(0)) {
    return
  }

  await requestFundsFromFaucet(addressBech32)

  for (let i = 0; i < 9; i++) {
    // Wait for the funds to reflect.
    await new Promise(f => setTimeout(f, 5000))

    let balance = await getAddressBalance(addressBech32)
    if (balance > BigInt(0)) {
      break
    }
  }
}

/** Returns the balance of the given Bech32-encoded address. */
async function getAddressBalance(addressBech32) {
  const outputIds = await client.basicOutputIds([
    { address: addressBech32 },
    { hasExpiration: false },
    { hasTimelock: false },
    { hasStorageDepositReturn: false },
  ])
  const outputs = await client.getOutputs(outputIds.items)

  let totalAmount = BigInt(0)
  for (const output of outputs) {
    totalAmount += output.output.getAmount()
  }

  return totalAmount
}

/** Request tokens from the faucet API. */
async function requestFundsFromFaucet(addressBech32) {
  const requestObj = JSON.stringify({ address: addressBech32 })
  let errorMessage, data
  try {
    const response = await fetch(FAUCET_ENDPOINT, {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      body: requestObj,
    })
    if (response.status === 202) {
      errorMessage = "OK"
    } else if (response.status === 429) {
      errorMessage = "too many requests, please try again later."
    } else {
      data = await response.json()
      // @ts-ignore
      errorMessage = data.error.message
    }
  } catch (error) {
    errorMessage = error
  }

  if (errorMessage != "OK") {
    throw new Error(`failed to get funds from faucet: ${errorMessage}`)
  }
}
