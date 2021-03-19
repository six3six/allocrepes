import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as https from "https";
import * as sxml from "sxml";


admin.initializeApp();

exports.ssoLogin = functions.https.onRequest(async (req, res) => {
    const fncUrl = `https://${req.header("host")}/${process.env.FUNCTION_TARGET}${req.path}`;
    const encUrl = encodeURIComponent(fncUrl);

    const ticket = req.query.ticket;

    const url = `https://sso.esiee.fr/cas/serviceValidate?service=${encUrl}&ticket=${ticket}`;

    const requestCall = new Promise<string>((resolve, reject) => {
        https.get(url,
            (response) => {
                const chunksOfData: any[] = [];

                response.on("data", (fragments) => {
                    chunksOfData.push(fragments);
                });

                response.on("end", () => {
                    const responseBody = Buffer.concat(chunksOfData);

                    // promise resolved on success
                    resolve(responseBody.toString());
                });

                response.on("error", (error) => {
                    // promise rejected on error
                    reject(error);
                });
            });
    });

    const result: string = await requestCall;

    const xmlS = new sxml.XML(result);

    console.log(result);

    const user: string = xmlS.get("cas:authenticationSuccess").front()
        .get("cas:user").front().getValue();

    console.log(`User: ${user}`);

    const token = await admin.auth().createCustomToken(user);

    console.log(`Token: ${token}`);

    res.json({
        user: user,
        token: token,
    });
});
