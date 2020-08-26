# TechChallengeApp - Configuration

This doc outlines how to configure the application using the config file. The main way to configure the application is through the configuration file, but it is possible to override the settings using environment variables.

## Configuration file

The application is configured using a file stored in the root directory of the application. It contains the configuration for the listener as well as the database connectivity details.

Example:

``` toml
"DbUser" = "postgres"
"DbPassword" = "changeme"
"DbName" = "app"
"DbPort" = "5432"
"DbHost" = "localhost"
"ListenHost" = "localhost"
"ListenPort" = "3000"
```

* `DbUser` - the user used to connect to the database server
* `DbPassword` - the password used to connect to the database server
* `DbName` - name of the database to use on the database server
* `DbPort` - port to connect to the database server on
* `DbHost` - host to connect to, ip or dns entry
* `ListenHost` - listener configuration for the application, 0.0.0.0 for all IP, or specify ip to listen on
* `ListenPort` - port to bind on the local server

## Environment Variables

The application will look for environment variables that are able to override the configuration defined in the `conf.toml` file. These environment variables are prefixed with `VTT` and follow this pattern `VTT_<conf value>`. e.g. `VTT_LISTENPORT`.

Environment variables has precedence over configuration from the `conf.toml` file

More details on each of the configuration values can be found in the section on the configuration file.
