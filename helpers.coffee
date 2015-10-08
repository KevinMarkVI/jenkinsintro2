seconds = 1000
defaultTimeout = 10 * seconds
exports.seconds = seconds
exports.defaultTimeout = defaultTimeout

usernameForm = By.className('username-input')
passwordForm = By.className('password-input')
submitForm = By.xpath("//button[@type='submit']")

exports.capitalize = (word) ->
    return word.charAt(0).toUpperCase() + word.slice 1

exports.login = (driver, user, pwd) ->
    user = user || "admin"
    pwd = pwd || user || "admin"

    driver.manage().deleteAllCookies()
    driver.navigate().refresh()

    driver.wait ( ->
        return driver.getCurrentUrl().then (url) ->
            return /login/.test(url)
    ), defaultTimeout

    #Ignore sending usage metrics during e2e testing - by setting an appropriate cookie
    driver.executeScript( ->
        $.cookie('usageStatistics', '{"consent":false,"lastConsentDate":1580544000000}', { path: '/' });
    )

    element(usernameForm).sendKeys(user)
    element(passwordForm).sendKeys(pwd)
    element(submitForm).click()

    return driver.wait ( ->
        return driver.getCurrentUrl().then (url) ->
            return not /login/.test(url)
    ), 10 * seconds

exports.navigateToRbac = (driver) ->
    element(By.xpath("//a[@href='/manage/']")).click()
    element(By.xpath("//a[@href='#rbac']")).click()

    driver.wait ( ->
        return driver.getCurrentUrl().then (url) ->
            return /rbac/.test(url)
    ), defaultTimeout

exports.createUser = (driver, user, pwd, privledges) ->
    # default to username for testing purposes
    pwd = pwd || user
    privledges = privledges || ['System']

    expect(exports.navigateToRbac(driver)).toBeTruthy()

    element(By.id('addUserButton')).click()

    driver.wait ( ->
        return element(By.css("div[role=dialog]")).then (modal) ->
            return element(By.css("div[role=dialog]")).getCssValue('opacity').then (opacity) ->
                return opacity is "1"
    ), defaultTimeout

    element(By.id('firstNameInput')).sendKeys(user)
    element(By.id('lastNameInput')).sendKeys(user)
    element(By.id('usernameInput')).sendKeys(user)
    element(By.id('passwordInput')).sendKeys(pwd)
    element(By.id('verifyPasswordInput')).sendKeys(pwd)

    element(By.className('selectize-input')).click()

    element(By.xpath("//div[contains(text(), '#{privledges}')]")).click()

    element(By.id('userForm')).click()

    driver.wait ( ->
        return element(By.id('submitButton')).getAttribute('disabled').then (disableAttr) ->
            return disableAttr is null
    ), defaultTimeout

    element(By.id('submitButton')).click()

    return driver.wait ( ->
        return element(By.xpath("//td[contains(text(), '#{user}')]")).isPresent()
    ), defaultTimeout

exports.deleteUser = (driver, username) ->
    deleteCheck = By.xpath("//td[contains(@class,'user-username') and contains(text(), '#{username}')]")

    expect(exports.navigateToRbac(driver)).toBeTruthy()

    element(deleteCheck).element(By.xpath('..')).then (user) ->
        user.element(By.css("input[class='user-checkbox']")).click()

    driver.findElement(By.id('deleteUsersButton')).click()
    driver.sleep(500)
    driver.findElement(By.id('deleteModalConfirmButton')).click()

    driver.sleep(1500)
    driver.navigate().refresh()

    return driver.wait ( ->
        return element.all(deleteCheck).count().then (count) ->
            return count is 0
    ), defaultTimeout

# Analytics dashboard helpers
exports.waitForEditorSlideDown = (driver,type) ->
    #wait for the slide down animation to finish
    if type=="custom"
        domHeight = 780
    else 
        domHeight = 490
    return driver.wait ( ->
        return element(By.className('report-editor-full')).getSize().then (size) ->
            return size.height > domHeight
    ), defaultTimeout

exports.waitForEditorSlideUp = (driver) ->
    #wait for the slide down animation to finish
    domHeight = 100
    return driver.wait ( ->
        return element(By.className('report-editor-view')).getSize().then (size) ->
            return size.height < domHeight
    ), defaultTimeout

exports.verifyElementPresent = (driver, locator) ->
    driver.wait ( ->
        return driver.isElementPresent(locator).then (isPresent) ->
              return isPresent
    ), 8 * seconds

exports.verifyElementNotPresent = (driver, locator) ->
    driver.wait ( ->
        return driver.isElementPresent(locator).then (isPresent) ->
              return isPresent==false
    ), 8 * seconds

exports.deleteReport = (reportItem) ->
    deleteButton = By.css('.delete-each-report-btn')
    reportItem.click()
    reportItem.element(deleteButton).click()
