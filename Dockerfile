FROM ruby:2.5-stretch

WORKDIR /usr/src/app

COPY . ./
RUN bundle install
RUN gem install guard guard-rspec guard-shell

CMD ["guard", "start", "--guardfile=/usr/src/app/Guardfile", "--no-interactions", "--no-bundler-warning"]
