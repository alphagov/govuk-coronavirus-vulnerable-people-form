describe('stripPII', function () {
  it ('returns an empty string given an empty string', function () {
    expect(stripPII('')).toEqual('')
  })

  it ('returns an empty string given a null', function () {
    expect(stripPII(null)).toEqual('')
  })

  it('returns an empty string given undefined', function () {
    expect(stripPII(undefined)).toEqual('')
  })

  it ('replaces nothing if there is no query string', function () {
    var givenURL = new URL('http://example.com/')
    var expectedURL = 'http://example.com/'

    expect(stripPII(givenURL)).toEqual(expectedURL)
  })

  it ('redacts reference_number', function() {
    var givenURL = new URL('http://example.com/?test=blah&reference_number=12345')
    var expectedURL = 'http://example.com/?test=<TEST>&reference_number=<REFERENCE_NUMBER>'

    expect(stripPII(givenURL)).toEqual(expectedURL)
  })

  it('redacts contact_gp', function() {
    var givenURL = new URL('http://example.com/?test=blah&contact_gp=12345')
    var expectedURL = 'http://example.com/?test=<TEST>&contact_gp=<CONTACT_GP>'

    expect(stripPII(givenURL)).toEqual(expectedURL)
  })

  it ('redacts all query string parameters', function() {
    var givenURL = new URL('http://example.com/?contact_gp=12345&test=blah&reference_number=12345')
    var expectedURL = 'http://example.com/?contact_gp=<CONTACT_GP>&test=<TEST>&reference_number=<REFERENCE_NUMBER>'

    expect(stripPII(givenURL)).toEqual(expectedURL)
  })

  it('redacts all query string parameters with a page link is present', function() {
    var givenURL = new URL('http://example.com/?test=blah&contact_gp=12345#page_link')
    var expectedURL = 'http://example.com/?test=<TEST>&contact_gp=<CONTACT_GP>#page_link'

    expect(stripPII(givenURL)).toEqual(expectedURL)
  })
})
