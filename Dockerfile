FROM ruby:2.6
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y --no-install-recommends nodejs \
  && rm -rf /var/lib/apt/lists/*
RUN gem install bundler sshake --no-doc
RUN mkdir -p /work /output /config
WORKDIR /work
COPY Gemfile Gemfile.lock ./
RUN bundle install -j 4
ENV APIA_SCHEMA_PATH /config/schema.json
ENV CONFIG_PATH /config/config.yaml
COPY . .
CMD ["ruby", "./run.rb"]
