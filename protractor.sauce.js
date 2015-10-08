exports.config = {

    sauceUser: process.env.SAUCE_USERNAME,
    sauceKey: process.env.SAUCE_ACCESS_KEY,

    // Capabilities to be passed to the webdriver instance.
    capabilities: {
        'browserName':'chrome',
        'name':'CMX Connect E2E UI Automation'
    },

    specs: [
        '*.coffee'
    ],

    onPrepare: function() {
        global.by = protractor.By;

        // Protractor expects to sync with angular, disable and replace w timeouts
        browser.ignoreSynchronization = true;
        browser.manage().timeouts().pageLoadTimeout(40000);
        browser.manage().timeouts().implicitlyWait(20000);
    },

    framework: 'jasmine',

    jasmineNodeOpts: {
        showColors: true,
        defaultTimeoutInterval: 60000,
        isVerbose: true,
        includeStackTrace: true,
        junit:true,
        realtimeFailure: true
    }
};
