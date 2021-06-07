#FIXME I don't really need bash to run shell script
FROM alpine:latest

ENV ADMINDBUSER=
ENV ADMINDBPASSWORD=
ENV DBHOST=
ENV DBPORT=
ENV DBUSER=
ENV DBPASSWORD=

RUN apk update
RUN apk add postgresql-client bash

COPY create-db-user.sh /run

ENTRYPOINT ["/run/create-db-user.sh"]

