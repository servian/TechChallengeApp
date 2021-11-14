#!/bin/sh

if [ -d "dist" ]; then
    rm -rf dist
fi

mkdir -p dist

go mod tidy

CGO_ENABLED="0" go build -ldflags="-s -w" -a -v -o TechChallengeApp .

pushd ui
rice append --exec ../TechChallengeApp
popd

cp TechChallengeApp dist/
cp conf.toml dist/

rm TechChallengeApp
