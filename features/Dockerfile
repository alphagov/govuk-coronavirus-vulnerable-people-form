#========================================================================================
# This Dockerfile creates a container image which contains ruby and google chrome,
# as well as the application source and bundled dependencies.
#
# This is needed for running the feature tests in a container environment like concourse.
#========================================================================================
FROM ruby:2.6.5-buster

RUN apt-get update --fix-missing && apt-get -y upgrade \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /src/*.deb

ENV CHROME_NO_SANDBOX=true

COPY Gemfile* .ruby-version /home/chrome/src/

WORKDIR /home/chrome/src

RUN bundle install

COPY . /home/chrome/src/

ENTRYPOINT ["/bin/bash"]
