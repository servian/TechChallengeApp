## Database management
Shallow image to run certain management tasks on RDS cluster

## Why
Well, we don't really want our application to use cluster administrator role. And we actually can't acheive that with ease as AWS cuts certain permissions from the master role.

## How
Simple template, docker image and a hint of orchestration required
