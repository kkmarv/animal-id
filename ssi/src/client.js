import {
  IotaIdentityClient
} from "@iota/identity-wasm/node/index.js"
import { Client } from "@iota/sdk-wasm/node/lib/index.js"
import { API_ENDPOINT } from "./util.js"


export const client = new Client({
  primaryNode: API_ENDPOINT,
  localPow: true,
})

export const didClient = new IotaIdentityClient(client)

