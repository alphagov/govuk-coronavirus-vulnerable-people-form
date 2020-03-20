# CoronavirusForm

This is an application for submitting a form.

## Getting started

The instructions will help you to get the application running
locally on your machine.

### Prequisites

You will need Postgres installed in order for bundler to install the `pg` gem (and `libpq-dev` if on Linux).  
You'll need a JavaScript runtime: https://github.com/rails/execjs  
Clone the app and run `bundle` locally.  

### Running Postgres

#### Locally

    brew install postgres
    postgres -D /usr/local/var/postgres

Then set up your local database

    rails db:setup

#### Docker

    docker pull postgres
    docker run -d -e POSTGRES_PASSWORD=password -e POSTGRES_USER=user -e POSTGRES_DB=coronavirus_form_development -p 5432:5432 postgres

Then set up your Docker database

    DATABASE_URL="postgres://user:password@localhost:5432/coronavirus_form_development" rails db:setup

You'll then need to specify the `DATABASE_URL` environment variable before the below tasks.

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
