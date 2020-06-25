#!/bin/bash

sudo ./metricbeat -e

docker run --name docker-collector-metrics \
--env LOGZIO_TOKEN="lspxRedIaPqUhEGDxhZSGvmXGSiHLIqG" \
--env LOGZIO_MODULES="aws" \
--env AWS_ACCESS_KEY="AKIAQQ5PDCWHHOSPWCES" \
--env AWS_SECRET_KEY="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" \
--env AWS_REGION="us-east-1" \
--env AWS_NAMESPACES="AWS/EC2,CWAgent,AWS/S3,AWS/Redshift" \
logzio/docker-collector-metrics

