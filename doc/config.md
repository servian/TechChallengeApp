# TechTestApp - Configuration

This doc outlines how to configure the application using the config file. All configuration of the application happens through the configuration file at this point. This was done to keep the application simple and easy to deploy.

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
