
import { createIdentity } from "./src/did_create.js";
import { resolveIdentity } from "./src/did_resolve.js";
import { createVC } from "./src/vc_create.js";
import { mnemonic, wallet } from "./src/wallet.js";
import { IotaDID, IotaDocument } from "@iota/identity-wasm/node/index.js";


import express from "express";
const app = express();


app.use(express.json());

const port = 3001;
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});

app.post("/create_identity", async (req, res)=> {
    res.json(
        await createIdentity(mnemonic, wallet)
    );
});
app.get("/resolve_identity", async (req,res)=> {
    let did = req.query.holder_id;
    // did
    res.json((await resolveIdentity(IotaDID.fromJSON(did))).toJSON());
})
app.post("/create_credential", async (req, res)=>{
    // beliebig (json)
    // did dokument
    // password
    let did = req.body.did;
    console.log(req.body);

    let subject = req.body.subject;

    res.json(await createVC(subject, await resolveIdentity(IotaDID.fromJSON(did)), mnemonic));
})