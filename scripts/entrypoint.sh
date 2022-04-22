#!/bin/sh

if [ "$1" = "seeddb" ]; then    
    ./TechChallengeApp updatedb -s
    ./TechChallengeApp serve
else
  ./TechChallengeApp serve
fi