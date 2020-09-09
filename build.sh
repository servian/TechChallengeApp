#!/bin/sh

if [ -d "dist" ]; then
    rm -rf dist
fi

mkdir -p dist

go mod tidy

go build -o TechChallengeApp.sh .

cp TechChallengeApp.sh dist/
cp -r assets dist/
cp conf.toml dist/

rm TechChallengeApp.sh
