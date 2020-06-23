#!/bin/sh
#Wait 10 seconds in order to allow for the database to be up and running.
sleep 10s;
#Execute database creation and seeding after which the web application will be served.
#Use for local development
./TechTestApp updatedb && ./TechTestApp serve;
#uncomment when deploying into GC, Azure or AWS; will require however that the database already exists.
#./TechTestApp updatedb -s && ./TechTestApp serve;