# 7. Application healthcheck failre results in http failed status code

Date: 2022-04-20

## Status

Review

## Context

Some cloud providers such as Azure make use of application healhchecks based on an endpoint that return an http failed status code on failure.
This change is essential to allow proper alerting systems in place. If the application cannot connect to a critical component, such as database, then the path should return a 500-level response code to indicate the app is unhealthy. See: https://docs.microsoft.com/en-us/azure/app-service/monitor-instances-health-check

## Decision

Change application healtcheck endpoint to return a 500-level response on failure (unhealthy status)

## Consequences

No expected consequences in other areas of the application code or infrastructure.
