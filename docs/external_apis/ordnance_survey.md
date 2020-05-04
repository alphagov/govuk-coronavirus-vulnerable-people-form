# Ordnance Survey Places API

Used by: AddressHelper::postcode_lookup

The Ordnance Survey Places API returns a list of UPRNs and specific address for a given postcode.

The default response excludes flats that do not have their own street address. To include them, `dataset=LPI` has been added to the query string.

`LPI` gives additional non-postcode address information - i.e. the bottom chunk for 10 downing st.  The default, `DPA` is limited to valid postcodes relating to that address only.

e.g. https://api.ordnancesurvey.co.uk/places/v1/addresses/postcode?dataset=LPI&postcode=SW1A2AA&key=<ORDNANCE_SURVEY_PLACES_API_KEY>

`ORDNANCE_SURVEY_PLACES_API_KEY` is defined in `govuk-secrets`


See [Ordnance Survey places API documentation](https://apidocs.os.uk/docs/os-places-technical-detail) for more information.
