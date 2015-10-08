((jasmine, driver) ->
    
    helpers = require('./helpers.coffee')
    timeout = helpers.defaultTimeout

    # report editor selectors
    portalTitleInput = By.css('.title.portal-name')
    portalTitleNextButton = By.css('.next-btn')
    portalName = (`"test-" + Math.random().toString(36).substring(2,5)`)
    jqteEditor = By.css('.el-item.el-item-content>.el-sub-content>.jqte>.jqte_editor')

    ##############  Portal Creation Test cases  ##################
    describe 'looking at the dashboard page', ->
        it 'should navigate to the connect experiences page', ->
            element(By.xpath("//a[@href='#experience']")).click()
            expect(driver.wait ( ->
                return driver.getCurrentUrl().then (url) ->
                   return /connect/.test(url) && /#experience/.test(url) 
            ), timeout).toBeTruthy()
    describe 'Create a portal from Portal Library', ->
        it 'Create a Portal from Portal Library', ->
            # check to see if we have any prior portals created 
            driver.findElement(By.css('.default-portal-btn')).then (() ->
               element(By.css('.portal-col>.btn-primary')).click() 
            ), () ->
               element(By.css('.portal-btn')).click()
               element(By.css('.dropdown-menu.portal-list > li:first-child a')).click()
            element(portalTitleInput).sendKeys(portalName)
            element(portalTitleNextButton).click()
            expect(driver.wait ( ->
                return driver.getCurrentUrl().then (url) ->
                    return /connect/.test(url) && /#experience/.test(url)
            ), timeout).toBeTruthy()

    describe 'Portal Editor Changes', ->
        it 'Remove Image, Add terms and save', ->
            browser.actions().click($('.cmx_portal_element_image')).perform()
            browser.actions().click($('.btn.btn-danger.edit.remove')).perform()
            browser.actions().click($('.confirm-remove>.btn.save-btn')).perform()
            browser.actions().click($('.cmx_portal_element_terms')).perform()
            element(jqteEditor).sendKeys("Terms and Conditions example text")
        it 'Perform Save Action', ->
            browser.actions().click($('.buttons.col-xs-6.text-right>.save-btn.btn.btn-primary')).perform()
            driver.sleep(5000)

)(jasmine, browser.driver)
