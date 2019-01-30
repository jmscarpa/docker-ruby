FROM ruby:2.5.1
LABEL maintainer "Embras Labs <labs@embras.net>"

EXPOSE 3000
WORKDIR /app

RUN apt-get update -qq && \
	apt-get install -y libpq-dev nodejs build-essential locales firebird-dev

ENV LANG C.UTF-8

COPY ./__docker/.irbrc /root
COPY ./__docker/.pryrc /root

# Reference: https://github.com/jfroom/docker-compose-rails-selenium-example
COPY ./__docker/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
RUN chmod +x /docker-entrypoint.sh

# Add bundle entry point to handle bundle cache
ENV BUNDLE_PATH=/.gems \
    BUNDLE_BIN=/.gems/bin \
    GEM_HOME=/.gems
ENV PATH="${BUNDLE_BIN}:${PATH}"