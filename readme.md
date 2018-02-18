# Vibrato Tech Test App

[![Build Status][circleci-badge]][circleci]
[![Release][release-badge]][release]
[![GoReportCard][report-badge]][report]
[![License][license-badge]][license]

[circleci-badge]: https://circleci.com/gh/vibrato/TechTestApp.svg?style=shield&circle-token=8dfd03c6c2a5dc5555e2f1a84c36e33bc58ad0aa
[circleci]: https://circleci.com/gh/vibrato/TechTestApp
[release-badge]: http://img.shields.io/github/release/vibrato/TechTestApp/all.svg?style=flat
[release]:https://github.com/vibrato/TechTestApp/releases
[report-badge]: https://goreportcard.com/badge/github.com/vibrato/TechTestApp
[report]: https://goreportcard.com/report/github.com/vibrato/TechTestApp
[license-badge]: https://img.shields.io/github/license/vibrato/TechTestApp.svg?style=flat
[license]: https://github.com/vibrato/TechTestApp/license

WARNING: This app is a work in progress and not ready yet

Single page application designed to be ran inside a container or on a vm (IaaS) with a postgres database to store data.

It is completely self contained, and should not require any additional dependencies to run.

## Install

1. Download latest binary from release
2. unzip into desired location
3. and you should be good to go

## Start server

update `conf.toml` with database settings

`./TechTestApp updatedb` to create a database and seed it with test data

`./TechTestApp serve` will start serving requests

## Interesting endpoints

`/` - root endpoint that will load the SPA
`/api/tasks/` - api endpoint to create, read, update, and delete tasks 
`/healthcheck/` - Used to validate the health of the application

## Compile from source

`go get -d github.com/Virato/TechTestApp`

run `build.sh`

the `dist` folder contains the compiled web package