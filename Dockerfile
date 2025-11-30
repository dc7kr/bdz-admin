# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base


# Rails app lives here
WORKDIR /rails

# Set production environment
ENV EDITOR="vim"

# install basic tools and deps
RUN apt-get update -qq && \
    apt-get --no-install-recommends -y install \
      curl libjemalloc2 libvips sqlite3 \
      libmariadb3 \
      git \
      vim \
      less \
      tzdata \
      locales

# Install app specific deps
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        texlive-latex-extra \
        texlive-lang-german \
        texlive-xetex \
        texlive-science \
        texlive-plain-generic \
        fontconfig \
        fonts-lato \
    	fonts-liberation \
      	uuid \
	pdftk 

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN sed -i '/de_DE.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config

RUN apt-get install --no-install-recommends -y libmariadb-dev libyaml-dev

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

########################
# Python Invoice Stage #
########################

FROM build AS python-invoice
# 
# Tex-Invoice python code 
#
# Dont use a python container here!
RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes pipx
ENV PATH="/root/.local/bin:${PATH}"
RUN pipx install poetry
RUN pipx inject poetry poetry-plugin-bundle
WORKDIR /srv/src/tex-invoices/src

COPY tex-invoices /srv/src/
RUN poetry bundle venv --python=/usr/bin/python3 --only=main /venv

WORKDIR /app

COPY tex-invoices/src/tex_invoices ./tex_invoices
COPY tex-invoices/gen_invoice.py .
COPY tex-invoices/locale.yml .
COPY tex-invoices/bin ./bin
COPY tex-invoices/custom/ ./custom


############################
# Production image stage
############################
FROM base AS prod

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    RAILS_SERVE_STATIC_FILES="1" \
    PATH=/rails/bin:${PATH} \
    VIRTUAL_ENV=/venv \
    TEX_INVOICES_CFG="/app/config/general_cfg.yaml" \
    LANG=de_DE.UTF-8  \
    LANGUAGE=de_DE:de \
    LC_ALL=de_DE.UTF-8

# Copy built artifacts: gems, application
COPY --from=rails /usr/local/bundle /usr/local/bundle
COPY --from=rails /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

# Invoice related stuff
COPY --from=python-invoice /venv /venv
COPY --from=python-invoice /app /opt/tex-invoices

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
    RAILS_SERVE_STATIC_FILES="1" \
    PATH=/rails/bin/:${PATH} \
    VIRTUAL_ENV=/venv \
    TEX_INVOICES_CFG="/opt/tex-invoices/config/general_cfg.yaml" \
    LANG=de_DE.UTF-8  \
    LANGUAGE=de_DE:de \
    LC_ALL=de_DE.UTF-8

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

# Invoice related stuff
COPY --from=python-invoice /venv /venv
COPY --from=python-invoice /app /opt/tex-invoices


USER rails:rails

CMD ["/bin/bash"]
