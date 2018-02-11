#!/bin/sh

if [ -d "dist" ]; then
    rm -rf dist
fi

mkdir -p dist

go build .

cp TechTestApp dist/
cp -r assets dist/
cp conf.toml dist/

rm TechTestApp