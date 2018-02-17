# Vibrato Tech Test App

This app is a work in progress and not ready yet

## Install

1. Download latest binary from release
2. unzip into desired location
3. and you should be good to go

## Start server

update `conf.toml` with database settings

`./TechTestApp updatedb` to create a database and seed it with test data

`./TechTestApp serve` will start serving requests

## Compile from source

`go get -d github.com/Virato/TechTestApp`

run `build.sh`

the `dist` folder contains the compiled web package