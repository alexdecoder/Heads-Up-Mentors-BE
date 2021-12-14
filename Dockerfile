FROM ruby:2.7.5
RUN apt-get update -qq && apt-get install -y nodejs

WORKDIR /app

# Application dependencies
COPY Gemfile Gemfile.lock ./

RUN gem install bundler && \
    bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install


# Copy application code to the container image
COPY . /app

#ENV RAILS_ENV=production
#ENV RAILS_SERVE_STATIC_FILES=true
#ENV RAILS_LOG_TO_STDOUT=true

EXPOSE 80

CMD ["rails", "server", "-b", "0.0.0.0"]