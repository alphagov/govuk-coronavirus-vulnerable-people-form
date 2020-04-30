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

### Running Sidekiq

We're using [Sidekiq][], a redis-backed queue, which plays nicely with ActiveJob
and ActionMailer, to send emails.

In staging and production, we run instances of the application as workers,
to process the email queue.

#### Locally

Sidekiq will start automatically when you run `foreman start`, but you can
also run it alone with `bundle exec sidekiq`.

[Sidekiq]: https://github.com/mperham/sidekiq

## Deployment pipeline

Every commit to master is deployed to GOV.UK PaaS by
[this concourse pipeline](https://cd.gds-reliability.engineering/teams/govuk-tools/pipelines/govuk-corona-vulnerable-people-form),
which is configured in [concourse/pipeline.yml](concourse/pipeline.yml).

The concourse pipeline has credentials for the `govuk-forms-deployer` user in
GOV.UK PaaS. This user has the SpaceDeveloper role, so it can `cf push` the application.
