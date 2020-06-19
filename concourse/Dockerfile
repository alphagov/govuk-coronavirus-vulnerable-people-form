#========================================================================================
# This Dockerfile creates a container image which contains ruby and google chrome,
# as well as the application source and bundled dependencies.
#
# This is needed for running the feature tests in a container environment like concourse.
#========================================================================================
FROM ruby:2.6.6-buster

RUN apt-get update --fix-missing && apt-get -y upgrade \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y --no-install-recommends \
      ./google-chrome-stable_current_amd64.deb \
      default-jre \
    && rm ./google-chrome-stable_current_amd64.deb


ENV CHROME_NO_SANDBOX=true

COPY Gemfile* .ruby-version /application/

WORKDIR /application/

RUN bundle install

COPY . /application/

ENTRYPOINT ["/bin/bash"]
