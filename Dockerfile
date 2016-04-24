FROM debian:jessie
MAINTAINER Yutaka Ichibangase <yichiban@gmail.com>
ADD . /app
WORKDIR /app
RUN ./provision.sh
RUN bundle config --global frozen 1
RUN bundle install
RUN rm -rf /var/lib/apt/lists/* /usr/lib/lib/ruby/gems/*/cache/* ~/.gem
EXPOSE 8080
CMD foreman start
