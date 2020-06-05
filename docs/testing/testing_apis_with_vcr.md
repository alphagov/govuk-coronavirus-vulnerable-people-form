
# Testing with VCR

> "Record your test suite's HTTP interactions and replay them during future test runs for fast, deterministic, accurate tests."

We are using [VCR](https://github.com/vcr/vcr) to record actual responses from an external API, and then use these saved responses (or cassette's as VCR calls them) to test our code, rather than manually creating stubs of the expected response.

Currently, VCR is only being used in the AddressHelper specs to test postcode lookup responses from the [Ordnance Survey places API](https://apidocs.os.uk/docs/os-places-technical-detail).

## Recording a new response

If you think the data may have changed, then you may need to record a new response from the actual API.  

To do this...

1. Update the `ORDNANCE_SURVEY_PLACES_API_KEY` environment variable in `config/application.rb` with the real API key from secrets:

```
ENV["ORDNANCE_SURVEY_PLACES_API_KEY"] = "123"
```

2. Update the test to record a new response
i.e. Change:

```
VCR.use_cassette "address/500_response" do
```
to:

```
VCR.use_cassette "address/500_response", record: :new_episodes do
```

3. Run the test again
4. The "cassette" e.g. `spec/vcr/address/500_response` should now have a new response entry.
5. Revert changes made in steps 1 and 2.

If you need to update **all** of the saved API responses - the best way is to simply delete the `address` directory - including all `.rb` files under it - within `spec/vcr`. Then re-run either the `spec/helpers/address_helper_spec.rb` test or all tests.

## Troubleshooting
If something goes wrong, VCR will throw a `VCR::Errors::UnhandledHTTPRequestError` error.

To see the stack trace, add a `binding.pry` to the test and run the code you're trying to test. VCR gives a very detailed description of what went wrong.

Things to check for are copy and paste errors for example. Make sure the query string parameters exactly match what's in the cassette under:

```
http_interactions:
- request:
    method: get
    uri: https://api.ordnancesurvey.co.uk/places/v1/addresses/postcode?dataset=LPI&postcode=SW1P2LQ&key=<ORDNANCE_SURVEY_PLACES_API_KEY>
```
