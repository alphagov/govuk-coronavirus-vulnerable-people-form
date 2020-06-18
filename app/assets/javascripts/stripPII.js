window.GOVUK = window.GOVUK || {}

var stripPII = function (url) {
  var _splitAndRedact = function (url) {
    var queryString = url.search.replace(/^\?/, '').split('&')
    var redactedArray = []

    for (var i = 0; i < queryString.length; i++) {
      if (queryString[i].startsWith('reference_number') || queryString[i].startsWith('contact_gp')) {
        var paramToRedact = queryString[i].split('=')
        redactedArray.push(paramToRedact[0] + '=<' + paramToRedact[0].toUpperCase() + '>')
      } else {
        if (queryString[i] !== '') redactedArray.push(queryString[i])
      }
    }

    return redactedArray.length > 0 ? '?' + redactedArray.join('&') : ''
  }

  try {
    return url.protocol + '//' + url.host + url.pathname + _splitAndRedact(url) + url.hash
  } catch (error) {
    console.error(error)
    return ''
  }
}

window.GOVUK.stripPII = stripPII
