import { didClient } from './client.js'


export async function resolveIdentity(did) {
    const resolved = await didClient.resolveDid(did)
    console.log("Resolved DID document:", JSON.stringify(resolved, null, 2))
    return resolved
}
