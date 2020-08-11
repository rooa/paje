FROM jayanthkoushik/paje

ADD www /www
ADD main.sh /main.sh

RUN cp -r /bundle/.bundle /www/.bundle
RUN cp /bundle/Gemfile /www/Gemfile
