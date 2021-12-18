FROM ruby:2.7.5

WORKDIR /app

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN gem install bundler

COPY Gemfile Gemfile.lock ./

RUN bundle install

# Copy application code to the container image
COPY . /app

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

EXPOSE 80

CMD ["./start.sh"]