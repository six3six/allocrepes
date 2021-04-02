import {TwitchChannel} from "twitch-channel";

const channel = new TwitchChannel({
    channel: process.env.CHANNEL,
    bot_name: process.env.BOT_NAME, // twitch bot login
    bot_token: process.env.BOT_TOKEN, // create your token here https://twitchapps.com/tmi/
    client_id: process.env.CLIENT_ID, // get it by registering a twitch app https://dev.twitch.tv/dashboard/apps/create (Redirect URI is not used)
    client_secret: process.env.SECRET, // secret of your registered twitch app
    port: 8443, // the lib will listen to this port
    callback_url: process.env.HOSTNAME + "/callback", // url to your server, accessible from the outside world
    secret: process.env.SECRET, // any random string
    is_test: false // set to true to listen to test donations and hosts from streamlabs
});


channel.on("debug", msg => console.log(msg));
channel.on("info", msg => console.log(msg));
channel.on("error", err => console.error(err));

channel.on("follow", event => {
    console.log("follow", event);
});
channel.on("stream-begin", event => {
    console.log("stream-begin", event);
});
channel.on("stream-change-game", event => {
    console.log("stream-change-game", event);
});
channel.on("stream-end", event => {
    console.log("stream-end", event);
});

(async () => {
    try {
        await channel.connect();
    } catch (e) {
        console.log(e);
    }
})();
