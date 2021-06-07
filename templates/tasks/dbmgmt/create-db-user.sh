#!/bin/bash
set -e

PGPASSWORD="$ADMINDBPASSWORD" psql -e -v ON_ERROR_STOP=1 --host "$DBHOST" --username "$ADMINDBUSER" --port "$DBPORT" --dbname postgres <<-EOSQL
    DROP DATABASE IF EXISTS app; -- get rid of database if exists
    CREATE USER $DBUSER WITH CREATEDB ENCRYPTED PASSWORD '$DBPASS'; -- create role
    GRANT $DBUSER to $ADMINDBUSER; -- weirdly, as admin user is cluster master acccount and RDS restricts this role quite harshly 
    CREATE DATABASE app OWNER $DBUSER; -- create database with owner
    GRANT ALL PRIVILEGES ON DATABASE app TO $DBUSER; -- redundant?
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $DBUSER; -- redundant?
EOSQL
