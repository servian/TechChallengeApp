#!/bin/bash

if [ "$(docker ps -a -q -f name=TechChallengeApp)" ]; then
    docker stop TechChallengeApp
    docker rm TechChallengeApp
fi
