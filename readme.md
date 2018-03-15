# Vibrato Tech Test

## Overview

Candidates are provided with this simple web application.

The candidate should then develop a solution to deploy this application to a cloud platform of their choice via an automated process utilising tooling of their choice.

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

- Clarity of code
- Comments where relevant
- Consistency of Coding

#### Security

- Network segmentation
- Secret storage
- Platform security features

#### Simplicity

- No superfluous dependencies
- Do not over engineer the solution

#### Resiliency

- Auto scaling and highly available frontend
- Highly available Database

## Tech Test Application

Single page application designed to be ran inside a container or on a vm (IaaS) with a postgres database to store data.

It is completely self contained, and should not require any additional dependencies to run.

## Compile from source

run `build.sh`

the `dist` folder contains the compiled web package

## Start server

update `conf.toml` with database settings

`./TechTestApp updatedb` to create a database and seed it with test data

`./TechTestApp serve` will start serving requests

## Interesting endpoints

`/` - root endpoint that will load the SPA

`/api/tasks/` - api endpoint to create, read, update, and delete tasks

`/healthcheck/` - Used to validate the health of the application