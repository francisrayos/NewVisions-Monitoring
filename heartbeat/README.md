# Welcome to Heartbeat 7.7.1

Ping remote services for availability and log results to Elasticsearch or send to Logstash.

## Getting Started

To get started with Heartbeat, you need to set up Elasticsearch on
your localhost first. After that, start Heartbeat with:

     ./heartbeat -c heartbeat.yml -e

This will start Heartbeat and send the data to your Elasticsearch
instance. To load the dashboards for Heartbeat into Kibana, run:

    ./heartbeat setup -e

For further steps visit the
[Getting started](https://www.elastic.co/guide/en/beats/heartbeat/7.7/heartbeat-getting-started.html) guide.

## Documentation

Visit [Elastic.co Docs](https://www.elastic.co/guide/en/beats/heartbeat/7.7/index.html)
for the full Heartbeat documentation.

## Release notes

https://www.elastic.co/guide/en/beats/libbeat/7.7/release-notes-7.7.1.html
