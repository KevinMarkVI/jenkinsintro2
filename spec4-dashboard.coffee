((jasmine, driver) ->
    
    helpers = require('helpers.coffee') 
    timeout = helpers.defaultTimeout

    ipAddress = process.env.IP_ADDRESS
    url = 'http://'+ipAddress+'/login/'
   
    newVisitor = By.css('#new-visitor-value')
    repeatVisitor = By.css('#repeat-visitor-value')

    ##############  Dashboard Test cases  ##################
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

    describe 'Verify the details in dashboard', ->
        it 'Check if the visitor count is incremented', ->
            expect(driver.findElement(By.id('total-visitor-value')).getText()).toBeTruthy()
        it 'Check if yesterday trend is not undefined', ->
            expect(driver.findElement(By.id('yesterday-trend-value')).getText()).toBeTruthy()
        it 'Check if Average trend is not undefined', ->
            expect(driver.findElement(By.id('average-trend-value')).getText()).toBeTruthy()
        it 'Check if Upload Data usage is not undefined', ->
            expect(driver.findElement(By.id('usage-up-value')).getText()).toBeTruthy()
        it 'Check if Download Data usage is not undefined', ->
            expect(driver.findElement(By.id('usage-down-value')).getText()).toBeTruthy()
        it 'Check if Charts exists on the page', ->
            expect(driver.findElement(By.css('.report-item-inner')).getText()).toBeTruthy()
        it 'Check if new visitor value is present and not defined', ->
            expect(element(newVisitor).isPresent()).toBeTruthy()

    describe 'Test Advanced Search', ->
        it 'Test Advanced Search Functionality', ->
            element(By.css('.btn.btn-default.wildSearch')).click()
        it 'Type the user entered value in Reg Form', ->
            element(By.css('.form-control.search')).sendKeys("cmxDemo")
        it 'Click on advanced Search', ->
            element(By.css('.btn-default.search')).click()
        it 'Check if table contains entered value', ->
            expect(element(By.css('td[title*="cmxDemo"]')).isPresent()).toBeTruthy()
)(jasmine, browser.driver)
