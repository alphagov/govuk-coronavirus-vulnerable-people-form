# Testing with VCR

We use [VCR](https://github.com/vcr/vcr) to record actual responses from an external API, and then use these responses to test our code, rather than manually creating stubs of the expected response.

At the moment VCR is only being used in the AddressHelper specs to test how responses from the [Ordnance Survey places API](https://apidocs.os.uk/docs/os-places-technical-detail) are used to do a postcode lookup.

## Recording a new response

If you think the data may have changed, then you'll need to record a new response.

1. Update this entry in `config/application.rb` with the real value from secrets:

```
ENV["ORDNANCE_SURVEY_PLACES_API_KEY"] = "123"
```

2. . Update the test to record a new response
i.e. Change:

```
VCR.use_cassette "address/500_response" do
```
to:

```
VCR.use_cassette "address/500_response", record: :new_episodes do
```

4. Run the test again
5. The "cassette" e.g. `spec/vcr/address/500_response` should have a new response entry.
6. Revert changes made in steps 1 - 3.


## Troubleshooting
If something goes wrong, VCR will throw a `VCR::Errors::UnhandledHTTPRequestError` error.

To see the stack trace, add a `binding.pry` to the test and run the code you're trying to test. VCR gives a very detailed description of what went wrong.

Things to check are things like copy and paste errors. Make sure the querystring parameters exactly match what's in the cassette under:

```
http_interactions:
- request:
    method: get
    uri: https://api.ordnancesurvey.co.uk/places/v1/addresses/postcode?dataset=LPI&postcode=SW1P2LQ&key=<ORDNANCE_SURVEY_PLACES_API_KEY>
```
