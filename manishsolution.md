10March2022 - Design approach
===========
Problem Statement: - Deploy TechChallenge APP to any cloud platform.
 0). Setup pipeline possibily using CircleCI with github trigger - Completed. 
 0). Setup network infra for deployment (infra as code)
 1). Set up new postgres database(infra as code)
 1.1) AWS Container setup to store applicaton
 2). Run app with updatedb option to generate tables (pipeline-docker)
 3). Provide the database configuration to web app and launch (pipeline-docker)
 4). Test connectivity on public dns

0). Setup CircleCI with github repo
1). Creation of network and database resoures on aws via terraform code 
   -> aws key and seceret store in environment variables
   -> environment variable for storing default DB user and password
   -> bucket is needed to store state file
2). 