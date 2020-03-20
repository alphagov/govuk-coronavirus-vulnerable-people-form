# CoronavirusForm

This is an application for submitting a form.

## Getting started

The instructions will help you to get the application running
locally on your machine.

### Prequisites

Clone the app and run `bundle` locally.  You will need Postgres installed in order for bundler to install the `pg` gem.

### Installing Postgres

    brew install postgres

### Running Postgres

     postgres -D /usr/local/var/postgres

### Set up your local database

    rails db:setup

### Running the application (Postgres will need to be running)

    foreman start

### Running the tests

    bundle exec rake

## Deployment pipeline

Every commit to master is deployed to GOV.UK PaaS by
[this concourse pipeline](https://cd.gds-reliability.engineering/teams/govuk-tools/pipelines/govuk-coronavirus-business-volunteer-form),
which is configured in [concourse/pipeline.yml](concourse/pipeline.yml).

The concourse pipeline has credentials for the `govuk-forms-deployer` user in
GOV.UK PaaS. This user has the SpaceDeveloper role, so it can `cf push` the application.

