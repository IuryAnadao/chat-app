FROM ruby:3.0.3

ADD . /var/www/app
WORKDIR /var/www/app

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y --allow-unauthenticated libicu-dev \
        libaio-dev \
        libpq-dev \
        redis-tools \
        vim \
        htop

RUN gem install rails \
    && gem install bundler:2.4.8 \
    && bundle install

RUN curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
RUN bash /tmp/nodesource_setup.sh
RUN apt install nodejs
RUN npm install --global yarn
RUN rails assets:precompile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]

CMD [ "./bin/dev" ]