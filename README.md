# Heartbeat

Server Monitoring & Live Tailing - DevOps Fellow Project @ Insight 



## Project Overview

Heartbeat is a monitoring dashboard solution, launched through Logz.io, a Grafana and ELK Stack-based
infrastructure monitoring tool.

![Image of Architecture](images/architecture.png)

## Prerequisites

You will need to configure AWS credentials before using this project. The following outlines the
process for a Linux operating system.

```
export AWS_ACCESS_KEY_ID=<<YOUR_AWS_ACCESS_KEY_ID>>           # input access key
export AWS_SECRET_ACCESS_KEY=<<YOUR_AWS_SECRET_ACCESS_KEY>>   # input secret key
source ~/.zshrc                                               # relaunch zsh
aws sts get-caller-identity                                   # confirm credentials
```

### Input Variables

```javascript
# AWS Region
aws_region = "us-east-1"

# My IP CIDR Blocks
ip_cidr_blocks = "<<YOUR IP ADDRESS>>/32"

# VPC for Redshift Cluster
vpc_cidr = "10.0.0.0/16"

# Redshift Subnets
redshift_subnet_cidr_1 = "10.0.1.0/24"
redshift_subnet_cidr_2 = "10.0.2.0/24"

# Define the Redshift Cluster
rs_cluster_identifier = "new-visions-cluster"
rs_database_name = "newvisionscluster"
rs_master_username = "newvisionsuser"
rs_master_pass = "NewVisions123"
rs_nodetype = "dc2.large"
rs_cluster_type = "single-node"

# EC2 Instance Variables
public_key_path1 = "airflow.pub"
public_key_path2 = "rstudio.pub"
private_key_path = "mykey"
airflow_instance_ami = "ami-02e4e4662a1a89f39"
airflow_instance_type = "t2.medium"
rstudio_instance_ami = "ami-0226a8af83fcecb43"
rstudio_instance_type = "t2.medium"
```

### Installing NodeJS, StatsD, and Airflow on EC2 Instance

## Beats Configuration

## Quick Start

## References & Quick Links