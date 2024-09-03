// Copyright 2020-2023 IOTA Stiftung
// SPDX-License-Identifier: Apache-2.0

import {
  Credential,
  EdDSAJwsVerifier,
  FailFast,
  JwsSignatureOptions,
  JwtCredentialValidationOptions,
  JwtCredentialValidator
} from "@iota/identity-wasm/node"
import { createDid } from "./util.js"
import { wallet } from './wallet.js'

/**
* This example shows how to create a Verifiable Credential and validate it.
*/
export async function createVC(subject, holderDocument, mnemonic) {
  // Create an identity for the imaginary issuer with one verification method `key-1`.
  let { document: issuerDocument, fragment: issuerFragment } = await createDid(
    mnemonic,
    wallet,
  )

  console.log("Imaginary issuer created.")

  // Subject should reference holder.
  subject["holder"] = holderDocument.id()

  // Create an unsigned credential.
  const unsignedVc = new Credential({
    id: "https://example.edu/credentials/3732",
    type: "AnimalIDCredential",
    issuer: issuerDocument.id(),
    credentialSubject: subject,
  })

  console.log("VC created.")

  // Create signed JWT credential.
  const credentialJwt = await issuerDocument.createCredentialJwt(
    wallet,
    issuerFragment,
    unsignedVc,
    new JwsSignatureOptions(),
  )
  console.log(`Credential signed > ${credentialJwt.toString()}`)

  // Before sending this credential to the holder the issuer wants to validate that some properties
  // of the credential satisfy their expectations.

  // Validate the credential's signature, the credential's semantic structure,
  // check that the issuance date is not in the future and that the expiration date is not in the past.
  // Note that the validation returns an object containing the decoded credential.
  const decoded_credential = new JwtCredentialValidator(new EdDSAJwsVerifier()).validate(
    credentialJwt,
    issuerDocument,
    new JwtCredentialValidationOptions(),
    FailFast.FirstError,
  )

  // Since `validate` did not throw any errors we know that the credential was successfully validated.
  console.log(`VC successfully validated`)

  const vc = decoded_credential.intoCredential()

  // The issuer is now sure that the credential they are about to issue satisfies their expectations.
  // Note that the credential is NOT published to the IOTA Tangle. It is sent and stored off-chain.
  console.log(`Issued credential: ${JSON.stringify(vc, null, 2)}`)

  return vc
}