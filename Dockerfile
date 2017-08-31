FROM ruby:2.1.4

RUN apt-get update && apt-get install -y --fix-missing build-essential

# for postgres
RUN apt-get install -y --fix-missing libpq-dev libmysqlclient-dev

# for nokogiri
RUN apt-get install -y --fix-missing libxml2-dev libxslt1-dev

# for capybara-webkit
RUN apt-get install -y --fix-missing libqt4-webkit libqt4-dev xvfb

# for a JS runtime
RUN apt-get install -y --fix-missing nodejs

ENV APP_HOME /myapp

RUN mkdir $APP_HOME

WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME

EXPOSE 3000
