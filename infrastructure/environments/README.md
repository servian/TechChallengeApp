This directory to contain different environment sub-directories.
All module implementation can be customised for each environments.

Example directories:
- dev
- staging
- integration
- acceptance
- pre-prod
- prod

``` sh
.
├── dev
├── dev
├── dev
├── dev
├── dev
├── dev
.
```

Either set up a root tf file at this location to run all environment at once or keep them individually within respective environment directories.
