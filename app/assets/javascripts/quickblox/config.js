var QBApp = {
    //appId: 28287,
    //authKey: 'XydaWcf8OO9xhGT',
    //authSecret: 'JZfqTspCvELAmnW'
   
    appId: 56717,
    authKey: '4D4Es2tWPAZ-tjG',
    authSecret: 'bukDf-HN3HqsWT3'
    
   // appId: 48913,
  // authKey: 'DptM7wcqOfFUuwV',
  // authSecret: 'qeuOjKtBTUuFd74'
};


var config = {
    chatProtocol: {
        active: 2
    },
   /* debug: {
        mode: 0,
        file: null
    }, */
    debug: true,
    webrtc: {
    answerTimeInterval: 60,
    dialingTimeInterval: 5
  }
};
var QBUser1 = {};
var QBUser2;
//var QBUser1 = {
//        id: 6729114,
//        name: 'quickuser',
//        login: 'chatusr11',
//        pass: 'chatusr11'
//    },
//    QBUser2 = {
//        id: 6729119,
//        name: 'bloxuser',
//        login: 'chatusr22',
//        pass: 'chatusr22'
//    };


//var QBUsers = [];

var QBUsers = [];


QB.init(QBApp.appId, QBApp.authKey, QBApp.authSecret, config);
