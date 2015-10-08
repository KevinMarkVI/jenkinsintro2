((jasmine, driver) ->
    
    helpers = require('./helpers.coffee')
    ipAddress = process.env.IP_ADDRESS

    timeout = helpers.defaultTimeout
    randomMac = (`"XX:XX:XX:XX:XX:XX".replace(/X/g, function() {
                  return "0123456789ABCDEF".charAt(Math.floor(Math.random() * 16))
                })`)
    url = 'http://'+ipAddress+'/visitor/login?switch_url=http://'+ipAddress+'&ap_mac=58:bc:27:92:51:c0&client_mac='+randomMac+'&wlan=tea&redirect=www.cnn.com/'
    name = By.css('#cmx_portal_element_field_1')
    email = By.css('#cmx_portal_element_field_2')

    ##############  Live View Test cases  ##################
    describe 'Going to the Connect pages and launch at dashboard', ->

        it 'should go to this link', ->
            browser.get(url);
        it 'Enter Name and email', ->
            element(name).sendKeys("cmxDemo")
            element(email).sendKeys("cmxdemo@cisco.com")
        it 'Check the terms and conditins checkbox', ->
            browser.actions().click($('.terms_conditions_checkbox')).perform()
        it 'Click Submit Button', ->
            element(By.css('.cmx_portal_element_content.ui-btn')).click()
            expect(driver.wait ( ->
                return driver.getCurrentUrl().then (url) ->
                    return /login/.test(url)
            ), timeout).toBeTruthy()
)(jasmine, browser.driver)
