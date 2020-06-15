![Run tests](https://github.com/alphagov/govuk-coronavirus-vulnerable-people-form/workflows/Run%20tests/badge.svg)

# CoronavirusForm

This is an application for submitting a form.

## Getting started

The instructions will help you to get the application running
locally on your machine.

### Prequisites

You'll need an Amazon DynamoDB local instance running in a docker container.

You'll need a JavaScript runtime: https://github.com/rails/execjs  
Clone the app and run `bundle` locally.  

### Running DynamoDB

#### Docker
Run the following to set up the local version of DynamoDB

```
    docker pull amazon/dynamodb-local
    docker run -d -p 8000:8000 amazon/dynamodb-local
```

### Running the application (DynamoDB will need to be running)

    foreman start

### Running the tests

    bundle exec rake

#### VCR

Some of our tests use [VCR](https://github.com/vcr/vcr) to generate stubbed responses. [Read about how to test with VCR](docs/testing/testing_with_vcr.md).

### Running Sidekiq

We're using [Sidekiq][], a redis-backed queue, which plays nicely with ActiveJob
and ActionMailer, to send emails.

In staging and production, we run instances of the application as workers,
to process the email queue.

#### Locally

Sidekiq will start automatically when you run `foreman start`, but you can
also run it alone with `bundle exec sidekiq`.

### Sending emails or SMSs locally

Change the delivery method in [development.rb][]:

```ruby
config.action_mailer.delivery_method = :notify_email
```

You'll then need to pass a GOV.UK Notify API key as an environment variable
`NOTIFY_API_KEY` as well the `GOVUK_NOTIFY_EMAIL_TEMPLATE_ID` and
`GOVUK_NOTIFY_SMS_TEMPLATE_ID` template IDs.

You can create an api key here: https://www.notifications.service.gov.uk/services/6ba785b8-71e0-4d0e-9f41-b7aa8876e5a9/api/keys

Make sure to pick either "Team and whitelist" or "Testing". The api key can be revoked later.

If you're testing SMS as well, make sure you have a mobile number associated with your Notify profile.

#### Running the app

```bash
GOVUK_NOTIFY_EMAIL_TEMPLATE_ID=<email_template_id_from_notify> GOVUK_NOTIFY_SMS_TEMPLATE_ID=<sms_template_id_from_notify> NOTIFY_API_KEY=<your_api_key> foreman start
```

If your Notify service doesn't have a template you'll need to create a template in Notify.

The template should have a Message of `((body))` only.

[Sidekiq]: https://github.com/mperham/sidekiq
[development.rb]: config/environments/development.rb

## Deployment pipeline

Every commit to master is deployed to GOV.UK PaaS by
[this concourse pipeline](https://cd.gds-reliability.engineering/teams/govuk-tools/pipelines/govuk-corona-vulnerable-people-form),
which is configured in [concourse/pipeline.yml](concourse/pipeline.yml).

The concourse pipeline has credentials for the `govuk-forms-deployer` user in
GOV.UK PaaS. This user has the SpaceDeveloper role, so it can `cf push` the application.

## How to deploy breaking changes

Details can be found [here](docs/how-to-deploy-breaking-changes).

## Licence

[MIT License](LICENCE)
