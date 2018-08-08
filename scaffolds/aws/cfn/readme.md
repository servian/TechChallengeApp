# AWS CloudFormation scaffolding

This scaffold will deploy the network layer in AWS using cloudformation.

## Requirements

stackup -[https://github.com/realestate-com-au/stackup](https://github.com/realestate-com-au/stackup)

## Instructions

Set up AWS credentials environment variables. e.g. AWS_PROFILE

Run `bootstrap.sh` from the scaffolding directory

To remove run `teardown.sh` from the scaffolding directory

## What will be deployed

A VPC with networking, routing and nats.

The VPC is laid out with 3 layers, public, private, and data.

> The template assumes 3 AZs, so if you are deploying somewhere with less it will need to be updated.

### Exports

* vibrato-network-VpcId
* vibrato-network-VpcCidr
* vibrato-network-SubnetPublicAz1
* vibrato-network-SubnetPublicAz2
* vibrato-network-SubnetPublicAz3
* vibrato-network-SubnetPrivateAz1
* vibrato-network-SubnetPrivateAz2
* vibrato-network-SubnetPrivateAz3
* vibrato-network-SubnetDataAz1
* vibrato-network-SubnetDataAz2
* vibrato-network-SubnetDataAz3

## Tested on

* MacOs