FROM ruby:2.4

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

# set locale
# RUN apt-get install -y locales
# RUN dpkg-reconfigure locales && \
#   locale-gen C.UTF-8 && \
#   /usr/sbin/update-locale LANG=C.UTF-8
# RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
#   locale-gen
# ENV LC_ALL C.UTF-8
# ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US.UTF-8