FROM ruby:2.6
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y --no-install-recommends nodejs
RUN gem install bundler -v 2.1.4 --no-doc
RUN mkdir -p /work /output /config
WORKDIR /work
COPY Gemfile Gemfile.lock ./
ARG github_package_key=none
COPY Gemfile Gemfile.lock ./
RUN BUNDLE_RUBYGEMS__PKG__GITHUB__COM=$github_package_key bundle install -j 4 --path vendor/bundle
ENV RAPID_SCHEMA_PATH /config/schema.json
ENV CONFIG_PATH /config/config.yaml
COPY . .
CMD ["bundle", "exec", "middleman", "build", "--build-dir=/output", "--verbose"]
