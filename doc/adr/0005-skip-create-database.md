# 5. skip create database

Date: 2018-08-19

## Status

Accepted

## Context

Database upgrade script contains everything required to deploy and seed a test database. Some PaaS services like azure db have requirements that means it is difficult to have a generic way to create the database.

## Decision

To make it easier, we've decided to add an option to skip the database creation and allow for an external process to create the database while still creating tables and seeding it with data.

## Consequences

none
