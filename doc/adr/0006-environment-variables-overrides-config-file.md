# 6. environment variables overrides config file

Date: 2018-08-22

## Status

Accepted

Supercedes [4. config only in config file](0004-config-only-in-config-file.md)

## Context

In some environments the port and other variables are only available on startup, and will have to be overriden. See https://github.com/servian/TechChallengeApp/issues/21

## Decision

Add environment variables overrides back

## Consequences

There are now two ways to configure the application, which causes more complexity
