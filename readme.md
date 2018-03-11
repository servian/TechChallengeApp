# Vibrato Tech Test

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

## Overview

Candidates are provided with this simple web application.

The candidate should then develop a solution to deploy the Latest Release from the GitHub Project to a cloud platform of their choice via an automated process utilising tooling of their choice.

## Assessment

Candidates should assume that the solution will be deployed to an empty cloud subscription with no existing infrastructure in place.

There *should not* be a requirement for Vibrato to access a candidate's cloud services account to deploy this solution.

Demonstrate regular commits and good git workflow practices.

There is no time limit for this test.

Candidates should provide documentation on their solution, including:

- Pre requisites for your deployment solution.
- High level architectural overview of your deployment.
- Process instructions for provisioning your solution.

## Assessment Grading Criteria

### Key Criteria

Candidates should take care to ensure that thier submission meets the following criteria:

- Must be able to start from a cloned git repo.
- Must document any pre-requisites clearly.
- Must be contained within a GitHub project.
- Must deploy via an automated process.

### Grading

Candidates will be assessed across the following categories:

#### Coding Style

- Clarity
- Comments
- Consistency

#### Security

- Network
- Secrets
- Platform Features

#### Simplicity

- Minimal superfluous dependencies
- Do not over engineer

#### Resiliency

- Auto scaling and highly available frontend
- Highly available Database

## Tech Test Application

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

`go get -d github.com/vibrato/TechTestApp`

run `build.sh`

the `dist` folder contains the compiled web package
