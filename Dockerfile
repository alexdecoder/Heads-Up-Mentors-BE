FROM ruby:3.0.3

WORKDIR /app

RUN apt-get update && apt-get install -y nodejs 

COPY Gemfile Gemfile.lock /app/

RUN gem install bundler && \
    bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
# Redirect Rails log to STDOUT for Cloud Run to capture
ENV RAILS_LOG_TO_STDOUT=true
# [START cloudrun_rails_dockerfile_key]
ARG MASTER_KEY
ENV RAILS_MASTER_KEY=${MASTER_KEY}
# [END cloudrun_rails_dockerfile_key]

COPY . /app

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]