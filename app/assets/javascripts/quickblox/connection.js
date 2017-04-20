//"use strict";

var currentUser;
var toidss = '';
var toname = "";

$(document).ready(function () {
	 var doctorEmail = Config.LOGGINED_USER_LOGIN;
     var doctorPassword = Config.LOGGINED_USER_PASS;


     var patientEmail = Config.DOC_PAT_USER_LOGIN;
     var patientPassword = Config.DOC_PAT_USER_PASS;
     
   
    QB.createSession(function (err, result) {
			QB.users.get({ email: doctorEmail }, function (error, response) {
				QB.users.get({ email: patientEmail }, function (err, res) {
						QBUser1 = {
							id: response.id,
							login: response.login,
							pass: doctorPassword,
							full_name: response.full_name
						};
						
						
						toidss = res.id;
						toname = res.login;
						
						
						currentUser = QBUser1;
						connectToChat(QBUser1);
				});
			});
    });
});

function connectToChat(user) {
    //$('#loginForm button').hide();
    //$('#loginForm .progress').show();

    console.log(user);

    // Create session and connect to chat
    //
    QB.createSession({ login: user.login, password: user.pass }, function (err, res) {

        if (res) {
            // save session token
            token = res.token;

            user.id = res.user_id;
            mergeUsers([{ user: user }]);

            QB.chat.connect({ userId: user.id, password: user.pass }, function (err, roster) {

                console.log(roster);
                console.log(err);

                if (err) {
                    console.log(err);
                } else {
                    //console.log(roster);
                    // load chat dialogs
                    //
                    retrieveChatDialogs();

                    // setup message listeners
                    //
                    setupAllListeners();

                    // setup scroll events handler
                    //
                    setupMsgScrollHandler();

                    //connect to new
                    // 
                    createNewDialog(toidss, toname);
                }
            });
        }
    });
}

function setupAllListeners() {
    QB.chat.onDisconnectedListener = onDisconnectedListener;
    QB.chat.onReconnectListener = onReconnectListener;
    QB.chat.onMessageListener = onMessage;
    QB.chat.onSystemMessageListener = onSystemMessageListener;
    QB.chat.onDeliveredStatusListener = onDeliveredStatusListener;
    QB.chat.onReadStatusListener = onReadStatusListener;
    setupIsTypingHandler();
}

// reconnection listeners
function onDisconnectedListener() {
    console.log("onDisconnectedListener");
}

function onReconnectListener() {
    console.log("onReconnectListener");
}


// niceScroll() - ON
$(document).ready(
    function () {
        $("html").niceScroll({ cursorcolor: "#02B923", cursorwidth: "7", zindex: "99999" });
        $(".nice-scroll").niceScroll({ cursorcolor: "#02B923", cursorwidth: "7", zindex: "99999" });
    }
);
