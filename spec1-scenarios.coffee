((jasmine, driver) ->
    helpers = require('./helpers.coffee')
    
    timeout = helpers.defaultTimeout
    ipAddress = process.env.IP_ADDRESS
    url = 'http://'+ipAddress+'/login/'
   
    ##############  Conncect Navigation Test cases  ##################
    describe 'Going to the Connect pages and launch at dashboard', ->
        it 'Should login as admin and launch Location view', ->
            browser.get(url);
            helpers.login(driver)
            expect(driver.wait ( ->
                return driver.getCurrentUrl().then (url) ->
                    return /location/.test(url) && /#map/.test(url)
            ), timeout).toBeTruthy()
        it 'should navigate to the connect page and show dashboard view', ->
            element(By.xpath("//a[@href='/connect/']")).click()
            expect(driver.wait ( ->
                return driver.getCurrentUrl().then (url) ->
                    return /connect/.test(url) && /#dashboard/.test(url)
            ), timeout).toBeTruthy()
            # in case we are doing a portal upgrade 
            driver.sleep(5000)
)(jasmine, browser.driver)
