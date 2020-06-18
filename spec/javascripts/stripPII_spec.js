describe('stripPII', function () {
  it ('returns an empty string given an empty string', function () {
    expect(stripPII('')).toEqual('')
  })

  it ('returns an empty string given a null', function () {
    expect(stripPII(null)).toEqual('')
  })

  it ('replaces nothing if there is no query string', function () {
    var givenURL = new URL('http://example.com/')
    var expectedURL = 'http://example.com/'

    expect(stripPII(givenURL)).toEqual(expectedURL)
  })

  it ('replaces nothing if there are no redactable params', function () {
    var givenURL = new URL('http://example.com/?test=blah')
    var expectedURL = 'http://example.com/?test=blah'

    expect(stripPII(givenURL)).toEqual(expectedURL)
  })

  it ('replaces reference_number', function() {
    var givenURL = new URL('http://example.com/?test=blah&reference_number=12345')
    var expectedURL = 'http://example.com/?test=blah&reference_number=<REFERENCE_NUMBER>'

    expect(stripPII(givenURL)).toEqual(expectedURL)
  })

  it('replaces contact_gp', function() {
    var givenURL = new URL('http://example.com/?test=blah&contact_gp=12345')
    var expectedURL = 'http://example.com/?test=blah&contact_gp=<CONTACT_GP>'

    expect(stripPII(givenURL)).toEqual(expectedURL)
  })

  it ('replaces both reference_number and contact_gp', function() {
    var givenURL = new URL('http://example.com/?contact_gp=12345&test=blah&reference_number=12345')
    var expectedURL = 'http://example.com/?contact_gp=<CONTACT_GP>&test=blah&reference_number=<REFERENCE_NUMBER>'

    expect(stripPII(givenURL)).toEqual(expectedURL)
  })

  it ('replaces contact_gp with a page link', function() {
    var givenURL = new URL('http://example.com/?test=blah&contact_gp=12345#page_link')
    var expectedURL = 'http://example.com/?test=blah&contact_gp=<CONTACT_GP>#page_link'

    expect(stripPII(givenURL)).toEqual(expectedURL)
  })
})
