10March2022 - Design approach
===========
Problem Statement: - Deploy TechChallenge APP to any cloud platform.
 0). Setup pipeline possibily using CircleCI with github trigger.
 0). Setup network infra for deployment (infra as code)
 1). Set up new postgres database(infra as code)
 2). Run app with updatedb option to generate tables (pipeline-docker)
 3). Provide the database configuration to web app and launch (pipeline-docker)
 4). Test connectivity on public dns


1) Planning Create Terraform code to deploy database and setup ECS 
