#!/bin/sh

if [ -d "dist" ]; then
    rm -rf dist
fi

mkdir -p dist

go mod tidy

go build -o TechChallengeApp .

cp TechChallengeApp dist/
cp -r assets dist/
cp conf.toml dist/

rm TechChallengeApp
