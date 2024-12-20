# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV EDITOR="vim"

# install basic tools and deps
RUN apt-get update -qq && \
    apt-get --no-install-recommends -y install \
      curl \
      libsqlite3-0 \
      libvips \
      libmariadb3 \
      libktoblzcheck1v5 \
      git \
      vim \
      less

# Install app specific deps
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        texlive-latex-extra \
        texlive-lang-german \
        texlive-xetex \
        texlive-science \
        texlive-plain-generic \
        fonts-lato \
    	fonts-liberation \
	pdftk 

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config

RUN apt-get install --no-install-recommends -y libmariadb-dev libktoblzcheck1-dev

#####################################
# Rails production preparation phase
#####################################
FROM build AS rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    RAILS_SERVE_STATIC_FILES="1" 

# Install application gems
COPY Gemfile Gemfile.lock ./

RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

COPY ./config/database.yml.dummy /rails/config/database.yml
COPY ./config/mongoid.yml.dummy /rails/config/mongoid.yml

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ASSET_PRECOMPILE=1 ./bin/rails assets:precompile

############################
# Production image stage
############################
FROM base AS prod

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    RAILS_SERVE_STATIC_FILES="1" 

# Copy built artifacts: gems, application
COPY --from=rails /usr/local/bundle /usr/local/bundle
COPY --from=rails /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

RUN rm -rf /var/lib/apt/lists /var/cache/apt/archives

USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]


####################
# Development Stage
####################
FROM build AS dev

ENV RAILS_ENV="development" \
    BUNDLE_PATH="/rails/.bundle" \
    BUNDLE_APP_CONFIG="/rails/bundle/.config" \
    BUNDLE_CONFIG="/rails/.bundle/config" \
    RAILS_SERVE_STATIC_FILES="1" 

# Network tools
RUN apt-get update -y && apt-get install --no-install-recommends -y \
        netcat-openbsd \
        bind9-dnsutils \
        iputils-ping \
        iproute2 \
        sudo

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash

RUN echo "rails ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER rails:rails

CMD ["/bin/bash"]
