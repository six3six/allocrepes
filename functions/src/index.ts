import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

exports.addMessage = functions.https.onRequest(async (req, res) => {
    res.json({result: `Message with ID: ${req.query.text} added.`});
});

exports.createToken = functions.https.onRequest(async (req, res) => {
    res.json({result: await admin.auth().createCustomToken("test"),});
});