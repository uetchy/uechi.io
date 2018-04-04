FROM ruby:2.5

# see http://stackoverflow.com/questions/38453963/gitlab-ci-setup-error-could-not-find-a-javascript-runtime
RUN apt-get update && apt-get install nodejs -y

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

ENV LANG C.UTF-8

WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app