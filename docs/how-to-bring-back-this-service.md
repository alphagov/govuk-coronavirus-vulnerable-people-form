# How to bring back the Extremely Vulnerable People Form

On 18th July 2020, this service was shut down. This was in line with Government policy.
The [landing page](https://www.gov.uk/coronavirus-extremely-vulnerable) was updated ahead of the service shutting down, to inform users that this change was coming.

In this case, the definition of ‘shutting down’ means that the site is still running, but is inaccessible to users.
The reason being, that we want to be in a position to be able to bring the service back up quickly if there is a resurgence of COVID 19.

## To bring back the service, these are the steps that will need to be taken

### Bring back the production smoke tests into the concourse pipeline

We removed the production smoke tests from our concourse pipeline.
This was because they made real requests to the application in production, so the tests would fail due to the requests being redirected.
To do this, we would need to revert the changes from [this PR](https://github.com/alphagov/govuk-coronavirus-vulnerable-people-form/pull/456).

### Scale up the number of PaaS instances
We scaled down the number of PaaS instances from 20 to 2.
We would need to scale back up, which can be done by reverting the changes in this [PR](https://github.com/alphagov/govuk-coronavirus-vulnerable-people-form/pull/455).

### Content changes to the landing page

A content designer will need to make changes to the landing page, using the [Publisher](https://github.com/alphagov/publisher) application.

### Remove the redirect from the CDN
We added a redirect to the CDN in order to redirect traffic to the landing page. This will need to be removed. To do this, remove this [Terraform code](https://github.com/alphagov/covid-engineering/pull/542) and apply the changes.

The same can be done for [staging](https://github.com/alphagov/covid-engineering/pull/530).
Confusingly, the staging terraform runs against a different staging cloudapps address to the staging smoke tests in our pipeline...
Ideally we would update the pipeline to just use one cloudapps address, but this has worked out quite conveniently as it has allowed us to continue deploying to a staging environment whilst the form is shut down.

### Update the Find Support application
We made changes to the Find Support application to [remove the link to this service](https://github.com/alphagov/govuk-coronavirus-find-support/pull/349), as well as [removing the question that resulted in the link displaying](https://github.com/alphagov/govuk-coronavirus-find-support/pull/353).
We would need to ensure that users were provided with a link to this service, through the Find Support application.
