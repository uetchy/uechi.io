FROM ruby:2.3

WORKDIR /usr/src/app/

# see http://stackoverflow.com/questions/38453963/gitlab-ci-setup-error-could-not-find-a-javascript-runtime
RUN apt-get update && apt-get install nodejs -y

COPY Gemfile /usr/src/app/
RUN bundle install