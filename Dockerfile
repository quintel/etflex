# FROM ruby:3.0

# LABEL maintainer="dev@quintel.com"

# # throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

# WORKDIR /usr/src/app

# COPY Gemfile Gemfile.lock ./
# RUN bundle install --jobs=4 --retry=3

# COPY . .

# CMD ["bin/rails", "s", "-b", "0.0.0.0"]
