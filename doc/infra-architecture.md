# CloudTechChallenge - Infrastrcture Architecture


## Network

The network is a single VPC which consists of 2 seperate private subnets:

### Networking Resources

|Type    | Name                                                          | CIDR        | Purpose                                                                     |
|--------|---------------------------------------------------------------|-------------|-----------------------------------------------------------------------------|
| VPC    | vpc-apse2-cloudtechchallenge                                  | 10.0.0.0/16 | VPC that contains all the resources for the cloudtechchallenge stack |
| Subnet | subnet-apse2-az1-private-cloudtechchallenge-application | 10.0.1.0/24 | Subnet for AZ1 that contains the ASG for the Fargate application containers |
| Subnet | subnet-apse2-az2-private-cloudtechchallenge-application | 10.0.2.0/24 | Subnet for AZ2 that contains the ASG for the Fargate application containers |
| Subnet | subnet-apse2-az1-private-cloudtechchallenge-database | 10.0.3.0/24 | Subnet for AZ1 that contains the master RDS instance |
| Subnet | subnet-apse2-az2-private-cloudtechchallenge-database | 10.0.4.0/24 | Subnet for AZ2 that contains the standby RDS instance |