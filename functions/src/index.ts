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

    console.log(`URL: ${url}`);

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


    const user: string = xmlS.get("cas:authenticationSuccess").front()
        .get("cas:user").front().getValue().toLowerCase();

    console.log(`User: ${user}`);

    const token = await admin.auth().createCustomToken(user);

    res.json({
        user: user,
        token: token,
    });
});

exports.onUserEdition = functions.firestore
    .document("users/{docId}")
    .onWrite(async (change, context) => {
        const prevData = change.before.data() ?? {"points": 0};
        const nextData = change.after.data() ?? {"points": 0};
        if (nextData["point"] > prevData["point"]) {
            const diff = nextData["point"] - prevData["point"];
            console.log("Send message to : " + change.after.id);
            await admin.messaging().sendToTopic(
                "/topics/user" + change.after.id,
                {
                    data: {},
                    notification: {
                        title: "Tu as gagné des points !",
                        body: `Tu as gagné ${diff} points !\n` +
                            "Zeus est très impressionné !",
                        sound: "default",
                        // badge: '1'
                    },
                },
                {
                    collapseKey: "point",
                    contentAvailable: true,
                    priority: "high",
                    timeToLive: 60 * 60 * 24,
                },
            );
        }
    });

