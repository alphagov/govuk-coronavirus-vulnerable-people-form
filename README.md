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
