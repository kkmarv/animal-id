// Example usage of this project's code.

import { createIdentity } from './did_create.js'
import { resolveIdentity } from './did_resolve.js'
import { createVC } from './vc_create.js'
import { mnemonic as holderMnemonic, wallet } from './wallet.js'


// Create holder DID (Farmer) and store in holder wallet
const holderDid = await createIdentity(holderMnemonic, wallet)

// Create sample cow DID and store in holder wallet
const cowDid = await createIdentity(holderMnemonic, wallet)

// Resolve the holder DID document
const holderDoc = await resolveIdentity(holderDid)

// Sample cow data
const cowData = {
  did: cowDid,
  badgeNumber: "1234",
  gender: "m",
  birthDate: "yesterday",
  mumBadgeNumber: "1",
  dadBadgeNumber: "2",
  race: "Mischling",
  mehrling: "Einling"
}

// (Self-) issue an AnimalID Credential
const vc = await createVC(cowData, holderDoc, holderMnemonic)
console.log(vc)

