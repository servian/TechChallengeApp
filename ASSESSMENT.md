# Assessment

Candidates should assume that the solution will be deployed to an empty cloud subscription with no existing infrastructure in place.

Candidates are free to use the most appropriate release package of the App for their platform and *should not* try to compile it themselves.

There *should not* be a requirement for Servian to access a candidate's cloud services account to deploy this solution.

Demonstrate regular commits and good git workflow practices.

There is no time limit for this challenge.

Candidates should provide documentation on their solution, including:

- Pre requisites for your deployment solution.
- High level architectural overview of your deployment.
- Process instructions for provisioning your solution.

## Assessment Grading Criteria

### Key Criteria

Candidates should take care to ensure that their submission meets the following criteria:

- Must be able to start from a cloned git repo.
- Must document any pre-requisites clearly.
- Must be contained within a GitHub repository.
- Must deploy via an automated process.
- Must deploy infrastructure using code.

### Grading

Candidates will be assessed across the following categories:

#### Coding Style

- Clarity of code
- Comments where relevant
- Consistency of Coding

#### Security

- Network segmentation (if applicable to the implementation)
- Secret storage
- Platform security features

#### Simplicity

- No superfluous dependencies
- Do not overengineer the solution

#### Resiliency

- Auto scaling and highly available frontend
- Highly available Database

## Tech Challenge Application

Single page application designed to be ran inside a container or on a vm (IaaS) with a postgres database to store data.

It is completely self contained, pre-built, and should not require any additional dependencies to run.

## Install

1. Download latest binary from release
2. unzip into desired location
3. and you should be good to go

### Alternativly

`docker pull servian/techchallengeapp:latest`

## Start server

update `conf.toml` with database settings

`./TechChallengeApp updatedb` to create a database and seed it with test data

`./TechChallengeApp serve` will start serving requests

## Interesting endpoints

`/` - root endpoint that will load the SPA

`/api/tasks/` - api endpoint to create, read, update, and delete tasks

`/healthcheck/` - Used to validate the health of the application

## Finally

More details about configuring the application can be found in the [document folder](doc/config.md)
