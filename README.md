# webaccess-analysis
Analyse web access logs and generate graphical statistics

## Goals
	1. Collecting web server logs in linux environment in real time 
	2. Demonstrate web access activities based on geo, hit rates, etc..
	3. Live dashboard
	4. Solutions available on AWS , including China and Global regions
	
## Solutions
### 1. Global solutions
- Kinesis Agent <-> Kinesis Firehose <-> Elastic Search <-> Kibana


/var/log/httpd/access_log
```Bash
172.31.4.203 - - [11/Dec/2016:03:18:03 +0000] "GET / HTTP/1.1" 200 99 "-" "ELB-HealthChecker/2.0"
172.31.29.210 - - [11/Dec/2016:03:18:05 +0000] "GET / HTTP/1.1" 200 99 "-" "ELB-HealthChecker/2.0"
172.31.58.251 - - [11/Dec/2016:03:18:11 +0000] "GET /path-a/index.html HTTP/1.1" 200 97 "-" "ELB-HealthChecker/2.0"
172.31.77.112 - - [11/Dec/2016:03:18:15 +0000] "GET /path-a/index.html HTTP/1.1" 200 97 "-" "ELB-HealthChecker/2.0"
172.31.77.2 - - [11/Dec/2016:03:18:25 +0000] "GET / HTTP/1.1" 200 99 "-" "ELB-HealthChecker/2.0"
172.31.62.128 - - [11/Dec/2016:03:18:27 +0000] "GET / HTTP/1.1" 200 99 "-" "ELB-HealthChecker/2.0"
172.31.4.203 - - [11/Dec/2016:03:18:33 +0000] "GET / HTTP/1.1" 200 99 "-" "ELB-HealthChecker/2.0"
172.31.29.210 - - [11/Dec/2016:03:18:35 +0000] "GET / HTTP/1.1" 200 99 "-" "ELB-HealthChecker/2.0"
```

log format: Apache log combined
/etc/httpd/conf/httpd.conf
```Bash
LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
CustomLog logs/access_log combined
```
[ Use the Agent to Pre-process Data ](http://docs.aws.amazon.com/firehose/latest/dev/writing-with-agents.html#pre-processing)

/etc/aws-kinesis/agent.json
```Bash
{
    "checkpointFile": "/tmp/aws-kinesis-agent-checkpoints",
    "cloudwatch.emitMetrics": true,
    "cloudwatch.endpoint": "https://monitoring.us-east-1.amazonaws.com",
    "firehose.endpoint": "https://firehose.us-east-1.amazonaws.com",
    "awsAccessKeyId": "xxxxx",
    "awsSecretAccessKey": "xxxxxxxxxx",

  "flows": [
    {
      "filePattern": "/var/log/httpd/access_log",
      "deliveryStream": "weblog-firehose",
      "dataProcessingOptions": [
      	{
        	"optionName": "LOGTOJSON",
        	"logFormat": "COMBINEDAPACHELOG"
        }
      ]
    }
  ]
}
```

ES Settings
  * Customize your template
```Bash

ENDPOINT="${YOUR_ES_ENDPOINT}"

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

- Kinesis Agent <-> Kinesis Stream <-> Lambda ( Geo enrichment ) <-> Elastic Search <-> Kibana

### 2. China solutions
- Kinesis Agent <-> Kinesis Stream <-> KCL applications (Geo enrichment ) <-> ES (Self build ) <-> Kibana 


