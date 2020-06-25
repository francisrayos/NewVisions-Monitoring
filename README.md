# Heartbeat

Server Monitoring & Live Tailing - DevOps Fellow Project @ Insight 

## Project Overview

Heartbeat is a monitoring dashboard solution, launched through Logz.io, a Grafana and ELK Stack-based
infrastructure monitoring tool. This project was launched as a pro-bono consulting project for New
Visions for Public Schools, who aimed to centralize a monitoring system for the tools and services in its
tech stack. The data team relies on a set of tools and services to process data provided by the Department of Education and other sources before feeding it into the tools and app that
the organization maintains. Heartbeat centralizes metric and log aggregation to monitor certain data pipelines and the health of EC2 instances, Airflow schedulers, and more. <br /><br />

![Image of Architecture](images/architecture.png)

## Tech Stack

| Technology    | Use Case      |
| ------------- | ------------- |
| Terraform  | Automate infrastructure  |
| AWS S3  | Data shipping to Redshifts  |
| AWS Redshift | Master data aggregation  |
| Airflow  | Manage processes on RStudio scripts  |
| RStudio Server  | Move and tranform data  |
| AWS Cloudwatch  | Metric aggregator for AWS tools  |
| StatsD  | Log aggregator for collecting Airflow metrics  |
| Beats | Log and metric shippers to Logz.io |
| Logz.io  | UI monitoring dashboard  |
| MongoDB  | Database configuration  |
| Tableau  | Database configuration  |
| PostgreSQL  | Database configuration  |

## Prerequisites

You will need to configure AWS credentials before using this project. The following outlines the
process for a Linux operating system.

```
export AWS_ACCESS_KEY_ID='<<YOUR_AWS_ACCESS_KEY_ID>>' >> ~/.zshrc           # input access key
export AWS_SECRET_ACCESS_KEY='<<YOUR_AWS_SECRET_ACCESS_KEY>>' >> ~/.zshrc   # input secret key
source ~/.zshrc                                                             # relaunch zsh
aws sts get-caller-identity                                                 # confirm credentials
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

To configure Airflow metrics, you must install [NodeJS](https://nodejs.org/en/download/package-manager/), [StatsD](https://github.com/statsd/statsd), and [Airflow](https://medium.com/@abraham.pabbathi/airflow-on-aws-ec2-instance-with-ubuntu-aff8d3206171) on the launched EC2 instance.

## Beats Configuration

## Quick Start

```
terraform init -var-file="variables.tfvars"
terraform apply -var-file="variables.tfvars"
```

```
ssh-keygen -f airflow 
ssh-keygen -f rstudio
```

```
sudo ./metricbeat -e

docker run --name docker-collector-metrics \
--env LOGZIO_TOKEN="lspxRedIaPqUhEGDxhZSGvmXGSiHLIqG" \
--env LOGZIO_MODULES="aws" \
--env AWS_ACCESS_KEY="AKIAQQ5PDCWHHOSPWCES" \
--env AWS_SECRET_KEY="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" \
--env AWS_REGION="us-east-1" \
--env AWS_NAMESPACES="AWS/EC2,CWAgent,AWS/S3,AWS/Redshift" \
logzio/docker-collector-metrics
```

```
node stats.js config.js > /path/to/output.txt

sudo ./filebeat -e
```

## References & Quick Links

- [How to Send Airflow Metrics to StatsD](https://airflow.apache.org/docs/stable/metrics.html)