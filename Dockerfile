FROM ruby:3.0.2
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /headsup-b
COPY Gemfile /headsup-b/Gemfile
COPY Gemfile.lock /headsup-b/Gemfile.lock
RUN gem install bundler
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
#comment
CMD ["rails", "server", "-b", "0.0.0.0"]