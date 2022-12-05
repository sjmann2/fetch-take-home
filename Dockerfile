# syntax=docker/dockerfile:1
FROM ruby:2.7.2
RUN apt-get update -qq && apt-get install -y postgresql-client
COPY . /fetch-take-home
WORKDIR /fetch-take-home
RUN gem install bundler:2.3.15 \
  && bundle config set force_ruby_platform true \
  && bundle install
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
