var QBApp = {
    appId: 56717,
    authKey: '4D4Es2tWPAZ-tjG',
    authSecret: 'bukDf-HN3HqsWT3'
};

var config = {
    chatProtocol: {
        active: 2
    },
    streamManagement: {
        enable: true
    },
    debug: {
        mode: 1,
        file: null
    }/*,
    stickerpipe: {
        elId: 'stickers_btn',
        apiKey: 'e45d4bfc831b0cd3aa1f9fc070014f9b',
        enableEmojiTab: true,
        enableHistoryTab: true,
        enableStoreTab: false,

        userId: null,

        priceB: '0.99 $',
        priceC: '1.99 $'
    }*/
};
/*
var QBUser1 = {
        id: 23285724,
        name: 'DemoChatUser1',
        login: 'DemoChatUser1',
        pass: 'DemoChatUser1'
    },
    QBUser2 = {
        id: 23285731,
        name: 'DemoChatUser2',
        login: 'DemoChatUser2',
        pass: 'DemoChatUser2'
    };
*/

var QBUser1 = {};
var QBUser2;

var QBUsers = [];


QB.init(QBApp.appId, QBApp.authKey, QBApp.authSecret, config);

$('.j-version').text('v.' + QB.version + '.' + QB.buildNumber);
