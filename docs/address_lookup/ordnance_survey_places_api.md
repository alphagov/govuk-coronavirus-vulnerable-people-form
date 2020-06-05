# Ordnance Survey Places API

Used by: AddressHelper::postcode_lookup

The [Ordnance Survey Places API](https://apidocs.os.uk/docs/os-places-technical-detail) returns a list of Unique Property Reference Numbers (UPRN) for a given postcode.

Why a list? Because relatively few postcodes indicate a single 'real'<sup>*</sup> address. The majority of postcodes cover multiple 'real' addresses within a single postcode.

Additionally, a postcode may also include non-addresses.  These are addresses that are covered by the postcode, but are **not** locations to which mail can be directed or delivered. In essence, a location to which the postal service does not have access. Such addresses are  indicated in the API response by having their `POSTAL_ADDRESS_CODE_DESCRIPTION` field set to `Not a postal address`.

To indicate this difference, the Places API offers two different datasets - or response types:

* `DPA` - is the default response dataset and only includes addresses that **are** 'real',
* `LPI` - this dataset includes all addresses for a given postcode - including the non-'real' ones.

To indicate to the API which dataset you are interested in receiving, a query string parameter is added - `dataset=DPA` or `dataset=LPI`.  As `DPA` is the default, `dataset=DPA` can be omitted from the query string.

For our purposes, we need the Places API to respond with `LPI` dataset entries.

For example...

```
https://api.ordnancesurvey.co.uk/places/v1/addresses/postcode?dataset=LPI&postcode=SW1A2AA&key=<ORDNANCE_SURVEY_PLACES_API_KEY>
```

The `ORDNANCE_SURVEY_PLACES_API_KEY` is defined in `govuk-secrets`.  You will require this API key should you need to (re)generate the VCR cassette saved API responses.

<sup>*</sup> A location to which a corespondent can direct mail, and to which that mail can be delivered.
