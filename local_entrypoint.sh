#!/bin/sh
#Wait 10 seconds in order to allow for the database to be up and running.
sleep 10s;
#Execute database creation and seeding after which the web application will be served.
./TechTestApp updatedb -s && ./TechTestApp serve;