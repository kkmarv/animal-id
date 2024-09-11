
import { IotaDID } from "@iota/identity-wasm/node/index.js"
import express from "express"
import { createIdentity } from "./src/did_create.js"
import { resolveIdentity } from "./src/did_resolve.js"
import { createVC } from "./src/vc_create.js"
import { mnemonic, wallet } from "./src/wallet.js"


const app = express()
const PORT = 3001

app.use(express.json())

app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`)
})

app.post("/create_identity", async (req, res) => {
    res.json(await createIdentity(mnemonic, wallet))
})
app.get("/resolve_identity", async (req, res) => {
    const did = req.query.holder_id
    res.json((await resolveIdentity(IotaDID.fromJSON(did))).toJSON())
})
app.post("/create_credential", async (req, res) => {
    const did = req.body.did
    const subject = req.body.subject
    res.json(await createVC(subject, await resolveIdentity(IotaDID.fromJSON(did)), mnemonic))
})