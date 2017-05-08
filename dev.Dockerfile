FROM ruby:2.1-alpine

MAINTAINER ZRP Aplicacoes Informaticas LTDA <zrp@zrp.com.br>

ENV BUILD_PACKAGES="curl-dev curl build-base alpine-sdk" \
    RUNTIME_PACKAGES="git zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev yaml nodejs openssl sqlite-dev sqlite-libs sqlite autoconf gcc g++ imagemagick-dev libtool make" \
    RACK_ENV=development RAILS_ENV=development \
    APP_PATH=/srv/app PATH=/srv/app/bin:$PATH \
    BUNDLE_GEMFILE=/srv/app/Gemfile BUNDLE_PATH=/srv/bin/app/bundle

WORKDIR $APP_PATH
EXPOSE 3000
VOLUME $APP_PATH $APP_PATH/log $APP_PATH/tmp

COPY Gemfile $APP_PATH
COPY Gemfile.lock $APP_PATH

RUN apk add --update --no-cache --virtual build-dependencies $BUILD_PACKAGES && \
    apk add --no-cache $RUNTIME_PACKAGES && \
    gem install nokogiri -v '1.6.6.2' -- --use-system-libraries --with-xml2-include=/usr/include/libxml2 --with-xml2-lib=/usr/lib && \
    gem install bundler --no-ri --no-rdoc && bundle install -j4 --retry 3 && \
    apk del build-dependencies

ENTRYPOINT ["./bin/docker-entrypoint"]

CMD ["/bin/ash"]
