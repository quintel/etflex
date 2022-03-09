FROM ruby:2.5-slim

LABEL maintainer="dev@quintel.com"

RUN apt-get update -yqq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yqq --no-install-recommends \
    automake \
    autoconf \
    build-essential \
    curl \
    default-libmysqlclient-dev \
    default-mysql-client \
    gnupg \
    nodejs

# Install Chrome for headless testing.
RUN curl -sS https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list && \
  apt-get update && apt-get install -y google-chrome-stable

RUN gem install bundler:1.17.3

COPY Gemfile* /app/
WORKDIR /app
RUN bundle install --jobs=4 --retry=3

COPY . /app/

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
