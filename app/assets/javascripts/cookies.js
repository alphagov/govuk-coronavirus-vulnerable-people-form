window.GOVUK = window.GOVUK || {}

function CookieSettings () {}

CookieSettings.start = function () {

  var cookieForm = document.querySelector('form[data-module=cookie-settings]');

  if (cookieForm) {
    cookieForm.addEventListener('submit', this.submitSettingsForm)
    this.setInitialFormValues()
  }
}

CookieSettings.setInitialFormValues = function () {
  if (!window.GOVUK.cookie('cookies_policy')) {
    window.GOVUK.setDefaultConsentCookie()
  }

  var currentConsentCookie = window.GOVUK.cookie('cookies_policy')
  var currentConsentCookieJSON = JSON.parse(currentConsentCookie)

  // We don't need the essential value as this cannot be changed by the user
  delete currentConsentCookieJSON["essential"]
  // We don't need the campaigns/settings values as these aren't required by
  // the service.
  delete currentConsentCookieJSON["campaigns"]
  delete currentConsentCookieJSON["settings"]

  for (var cookieType in currentConsentCookieJSON) {
    var radioButton

    if (currentConsentCookieJSON[cookieType]) {
      radioButton = document.querySelector('input[name=cookies-' + cookieType + '][value=on]')
    } else {
      radioButton = document.querySelector('input[name=cookies-' + cookieType + '][value=off]')
    }

    radioButton.checked = true
  }
}

CookieSettings.submitSettingsForm = function (event) {
  event.preventDefault()

  var formInputs = event.target.getElementsByTagName("input")
  var options = {}

  for ( var i = 0; i < formInputs.length; i++ ) {
    var input = formInputs[i]
    if (input.checked) {
      var name = input.name.replace('cookies-', '')
      var value = input.value === "on" ? true : false

      options[name] = value
    }
  }

  window.GOVUK.setConsentCookie(options)
  window.GOVUK.setCookie('cookies_preferences_set', true, { days: 365 });

  CookieSettings.showConfirmationMessage()

  if (window.GOVUK.analyticsInit) {
    window.GOVUK.analyticsInit()
  }

  return false
}

CookieSettings.showConfirmationMessage = function () {
  var confirmationMessage = document.querySelector('div[data-cookie-confirmation]')

  document.body.scrollTop = document.documentElement.scrollTop = 0

  confirmationMessage.style.display = "block"
}
