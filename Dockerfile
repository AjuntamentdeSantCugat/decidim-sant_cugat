FROM ruby:2.4.1
MAINTAINER david.morcillo@codegram.com

ARG rails_env=production
ARG secret_key_base=

ENV APP_HOME /code
ENV RAILS_ENV $rails_env
ENV SECRET_KEY_BASE $secret_key_base

RUN apt-get update

RUN curl -sL https://deb.nodesource.com/setup_5.x | bash && \
    apt-get install -y nodejs

RUN apt-get install -y p7zip
RUN apt-get install -y xfonts-base
RUN apt-get install -y xfonts-75dpi
RUN curl "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb" -L -o "wkhtmltox_0.12.6-1.bionic_amd64.deb"
RUN dpkg -i wkhtmltox_0.12.6-1.bionic_amd64.deb

ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock
RUN cd /tmp && bundle install

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME

RUN bundle exec rake DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname assets:precompile

CMD ["bundle", "exec", "rails", "s", "-b0.0.0.0"]
