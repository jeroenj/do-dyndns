FROM ruby:2.4.1-alpine

RUN apk upgrade --no-cache && \
    apk add --no-cache bind-tools

ADD Gemfile Gemfile.lock /app/
WORKDIR /app

RUN bundle install

ADD . /app

CMD ["bundle", "exec", "dns.rb"]
