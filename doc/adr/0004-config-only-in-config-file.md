# 4. config only in config file

Date: 2018-08-12

## Status

Superceded by [6. environment variables overrides config file](0006-environment-variables-overrides-config-file.md)

## Context

Application configuration can be overridden by command line flags and environment variables. Is this something we want to take advantage of?

## Decision

No, configuration will be limited to the configuration file for sake of simplicity and having a single way to configure the application.

## Consequences

Command line parameters and environment variables will be ignored and not taken into account when starting the application
