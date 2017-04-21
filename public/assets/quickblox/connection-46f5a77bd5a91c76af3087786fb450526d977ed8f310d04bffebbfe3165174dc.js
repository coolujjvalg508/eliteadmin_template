'use strict';

var currentUser;
var toidss = '';
var toname = "";
var token = "";

$(function() {
    
    /*$('#loginForm').modal('show');
    $('#loginForm .progress').hide();

    $('#user1').on('click', function() {
        currentUser = QBUser1;
        connectToChat(QBUser1);
    });

    $('#user2').on('click', function() {
        currentUser = QBUser2;
        connectToChat(QBUser2);
    });*/


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




    var niceScrollSettings = {
        cursorcolor:'#02B923',
        cursorwidth:'7',
        zindex:'99999'
    };

    $('html').niceScroll(niceScrollSettings);
    $('.nice-scroll').niceScroll(niceScrollSettings);
});

function connectToChat(user) {
   /* $('#loginForm button').hide();
    $('#loginForm .progress').show();*/




    QB.createSession({login: user.login, password: user.pass}, function(err, res) {
        if (res) {
            token = res.token;
            user.id = res.user_id;

            mergeUsers([{user: user}]);

            QB.chat.connect({userId: user.id, password: user.pass}, function(err, roster) {
                if (err) {
                    console.log(err);
                } else {
                    // setup scroll stickerpipe module
                    setupStickerPipe();

                    retrieveChatDialogs();

                    // setup message listeners
                    setupAllListeners();

                    // setup scroll events handler
                    setupMsgScrollHandler();

                    setupStreamManagementListeners();
                }
            });
        }
    });
}

function setupAllListeners() {
  QB.chat.onMessageListener         = onMessage;
  QB.chat.onSystemMessageListener   = onSystemMessageListener;
  QB.chat.onDeliveredStatusListener = onDeliveredStatusListener;
  QB.chat.onReadStatusListener      = onReadStatusListener;

  setupIsTypingHandler();
}
// reconnection listeners
function onDisconnectedListener(){
  console.log("onDisconnectedListener");
}

function onReconnectListener(){
  console.log("onReconnectListener");
}


// niceScroll() - ON
$(document).ready(
    function() {
        
    }
);
