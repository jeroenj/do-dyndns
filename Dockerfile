FROM ruby:2.6.4-alpine

RUN apk upgrade --no-cache && \
    apk add --no-cache bind-tools && \
    adduser -S do-dyndns

USER do-dyndns

ADD Gemfile Gemfile.lock /app/
WORKDIR /app

RUN bundle install

ADD . /app

CMD ["bundle", "exec", "dns.rb"]
