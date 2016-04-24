#!/usr/bin/env bash

# Avoid whiptail
export DEBIAN_FRONTEND=noninteractive

apt-add-repository ppa:brightbox/ruby-ng
apt-get update
apt-get install -y \
  autoconf \
  build-essential \
  git \
  imagemagick \
  libbz2-dev \
  libcurl4-openssl-dev \
  libevent-dev \
  libffi-dev \
  libglib2.0-dev \
  libjpeg-dev \
  libmagickcore-dev \
  libmagickwand-dev \
  libmysqlclient-dev \
  libncurses-dev \
  libpq-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libxml2-dev \
  libxslt1-dev \
  libyaml-dev \
  nodejs \
  ntp \
  ruby2.3 \
  ruby2.3-dev \
  zlib1g-dev

gem install bundler

# clean up caches
rm -rf /var/lib/apt/lists/*
rm -rf /usr/lib/lib/ruby/gems/*/cache/*
rm -rf ~/.gem
