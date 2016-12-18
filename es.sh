#!/bin/bash

#curl -XGET 'http://search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com/_cat'

#curl -XDELETE 'http://search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com/logstash-weblogs-2016-11-30'

#exit 0

# Customer mapping
# LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
# “%{host} %{ident} %{authuser} [%{datetime}] \"%{request}\" %{response} %{bytes} %{referrer} %{agent}”
# 172.31.77.2 - - [27/Nov/2016:03:39:14 +0000] "GET / HTTP/1.1" 200 99 "-" "ELB-HealthChecker/2.0"
# Datatype
# https://www.elastic.co/guide/en/elasticsearch/reference/2.3/mapping-types.html

ENDPOINT="search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com"

#curl -XDELETE "http://${ENDPOINT}/logstash-weblogs-2016-12-01"

#exit 0
curl -XPUT "http://${ENDPOINT}/_template/logstash" -d '
{
     "template": "logstash-*",
     "mappings": {
          "type1": {
               "properties": {
					"host": {
                         "type": "string"
					},
					"ident": {
                         "type": "string"
					},
					"authuser": {
                         "type": "string"
					},
                    "datetime": {
                         "type": "date",
                         "format": "dd/MMM/yyyy:HH:mm:ss +0000"
                    },
                    "request": {
                         "type": "string"
                    },
                    "response": {
                         "type": "integer"
                    },
                    "bytes": {
                         "type": "integer"
                    },
                    "referrer": {
                         "type": "string"
                    },
                    "agent": {
                         "type": "string"
                    },
                    "country": {
                         "type": "string"
                    },
                    "location": {
                         "type": "geo_point"
                    }
               }
          }
     }
}'
