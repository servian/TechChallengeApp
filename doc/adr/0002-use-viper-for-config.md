# 2. Use viper for config

Date: 2018-08-08

## Status

Accepted

## Context

The solution was built using a custom toml configuration solution, should we standardise on a library for less maintnance overhead?

## Decision

Decided to use viper as the configuration library, as it tightly integrates with cobra which we already use for helping with command line integration.

## Consequences

A few known issues around managing missing files with viper, but our process is set up to always have a file available so it shouldn't be a bit issue for us.