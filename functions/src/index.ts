import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as https from "https";
import * as sxml from "sxml";

admin.initializeApp();
const db = admin.firestore();

interface Token {
    user: string;
    token: string;
}

const isAdmin = async (user: string | undefined): Promise<boolean> => {
  if (user == undefined) return false;
  const adminRef = db.collection("roles").doc("admins");
  const adminVal = await adminRef.get();
  return adminVal.get(user) != undefined;
};

const getSSOToken = async (fncUrl: string, ticket: string): Promise<Token> => {
  const encUrl = encodeURIComponent(fncUrl);
  if (ticket == "" || ticket == undefined) {
    console.warn("VOID TICKET !!!!!");
    console.log();
    const token = await admin.auth().createCustomToken("invite");
    return {
      user: "invite",
      token: token,
    };
  }

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

  console.log(result);

  const xmlS = new sxml.XML(result);


  const user: string = xmlS.get("cas:authenticationSuccess").front()
      .get("cas:user").front().getValue().toLowerCase();

  console.log(`User: ${user}`);

  const token = await admin.auth().createCustomToken(user);
  return {
    user: user,
    token: token,
  };
};

exports.ssoLogin = functions.https.onRequest(async (req, res) => {
  const fncUrl = `https://${req.header("host")}/${process.env.FUNCTION_TARGET}${req.path}`;
  const ticket = typeof req.query.ticket === "string" ? req.query.ticket : "";

  const token = await getSSOToken(fncUrl, ticket);


  if (ticket == "") {
    console.log("No ticket returned. Query :");
    console.log(req.query);
  }

  res.redirect(`selva-auth://?token=${token.token}&user=${token.user}`);
});

exports.ssoLoginToken = functions.https.onRequest(async (req, res) => {
  const fncUrl = `https://${req.header("host")}/${process.env.FUNCTION_TARGET}${req.path}`;
  const ticket = typeof req.query.ticket === "string" ? req.query.ticket : "";
  const token = await getSSOToken(fncUrl, ticket);

  res.send(token.token);
});

exports.onPointChange = functions.firestore
    .document("users/{docId}")
    .onWrite(async (change, context) => {
      const prevData = change.before.data() ?? {"points": 0};
      const nextData = change.after.data() ?? {"points": 0};

      if (nextData["point"] != prevData["point"]) {
        let user = context.auth?.uid;
        if (user == undefined) {
          user = "undefined";
        }

        await db.collection("rules_points").add({
          date: new Date().toISOString(),
          data: nextData["point"] - prevData["point"],
          user: user,
        });
      }

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

exports.onRulesChange = functions.firestore
    .document("rules/{docId}")
    .onWrite(async (change, context) => {
      let user = context.auth?.uid;
      if (user == undefined) {
        user = "undefined";
      }
      await db.collection("rules_logs").add({
        date: new Date().toISOString(),
        data: JSON.stringify(change.after.data()),
        user: user,
      });
    });


exports.onCommandStatusChange = functions.firestore
    .document("orders/{docId}")
    .onWrite(async (change, context) => {
      const prevData = change.before.data() ?? {"status": 0};
      const nextData = change.after.data() ?? {"status": 0};

      if (prevData["status"] == nextData["status"]) return;

      let title = "";
      let body = "";

      switch (nextData["status"]) {
        case OrderStatus.UNKNOWN:
          title = "Oh non, votre commande est tombée dans la matrice...";
          body = "Votre commande est dans un état inconnu";
          break;
        case OrderStatus.CANCELED:
          title = "Oh non, votre commande a été annulé";
          body = "Malheureusement, votre commande a été annulé";
          break;
        case OrderStatus.VALIDATING:
          title = "Votre commande est encours de validation !";
          body = "";
          break;
        case OrderStatus.DELIVERING:
          title = "Votre commande arrive !";
          body = "Préparez vous, votre commande est encours de livraison";
          break;
        case OrderStatus.DELIVERED:
          title = "Bon appétit";
          body = "Votre commande est arrivée et est prête à être degustée\n" +
                "Bon appétit et merci pour votre commande";
          break;
        case OrderStatus.PENDING:
          title = "On cuisine pour vous !";
          body = "Votre commande est encours de fabrication";
          break;
        default:
          console.error("bad state " + nextData["status"].toString());
          return;
      }

      const user = nextData["owner"].toLowerCase();

      admin.messaging().sendToTopic(
          "/topics/user" + user,
          {
            data: {"type": "order"},
            notification: {
              title: title,
              body: body,
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

      console.log("Sending order modif to " + user);
    });


enum OrderStatus {
    UNKNOWN,
    VALIDATING,
    PENDING,
    DELIVERING,
    DELIVERED,
    CANCELED,
}

exports.getPointsCls = functions.https.onCall(async (requestData, context) => {
  const users = await db.collection("users").orderBy("point", "desc")
      .limit(5).get();
  return users.docs.map((doc) =>
    doc.get("surname") + " " + doc.get("name") + " : " + doc.get("point"),
  );
});

exports.sendNotif = functions.https.onCall(async (requestData, context) => {
  if (!await isAdmin(context.auth?.uid)) {
    console.log("Demande non autorisée notif : " + context.auth?.uid);
    return "Error";
  }


  await db.collection("notifLogs").add({
    date: new Date().toISOString(),
    sender: context.auth?.uid,
    recipient: requestData.recipient,
    action: requestData.action,
    title: requestData.title,
    body: requestData.body,
    link: requestData.link,
    user: requestData.user,
  });


  let data = {};

  const notification: admin.messaging.NotificationMessagePayload = {
    title: requestData.title,
    body: requestData.body,
    sound: "default",
    // badge: '1'
  };

  const option: admin.messaging.MessagingOptions = {
    contentAvailable: true,
    priority: "high",
    timeToLive: 60 * 60 * 24,
  };


  if (requestData.action == NotifAction.LinkPage) {
    data = {
      "link": requestData.link,
    };
  } else if (requestData.action == NotifAction.OrderPage) {
    data = {
      "type": "order",
    };
  }

  const payload: admin.messaging.MessagingPayload = {
    data: data,
    notification: notification,
  };

  let topic = "/topics/allusers";
  if (requestData.recipient == NotifRecipient.Ios) {
    topic = "/topics/iosusers";
  } else if (requestData.recipient == NotifRecipient.Android) {
    topic = "/topics/androidusers";
  } else if (requestData.recipient == NotifRecipient.User) {
    console.log(`sending message to ${requestData.user}`);
    topic = "/topics/user" + requestData.user;
  }


  await admin.messaging().sendToTopic(
      topic,
      payload,
      option,
  );


  return "ok";
});

enum NotifRecipient {
    Everybody,
    Android,
    Ios,
    User,
}

enum NotifAction {
    MainPage,
    OrderPage,
    LinkPage,
}

