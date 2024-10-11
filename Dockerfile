# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.2.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs freetds-dev

# Install Bundler
RUN gem install bundler

# Copy Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install gems using bundler
RUN bundle install

# Copy the rest of your application code into the container
COPY . .

# Expose port 3000 for the Rails application
EXPOSE 3000

# Start the Rails server
CMD ["bash", "-c", "rails server -b 0.0.0.0 && rails dev:cache"]
