FROM ruby:3.0.3
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

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
# Redirect Rails log to STDOUT for Cloud Run to capture
ENV RAILS_LOG_TO_STDOUT=true
# [START cloudrun_rails_dockerfile_key]
ARG MASTER_KEY
ENV RAILS_MASTER_KEY=${MASTER_KEY}
# [END cloudrun_rails_dockerfile_key]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]