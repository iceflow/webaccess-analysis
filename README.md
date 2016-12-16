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
- Kinesis Agent <-> Kinesis Stream <-> Lambda ( Geo enrichment ) <-> Elastic Search <-> Kibana

### 2. China solutions
- Kinesis Agent <-> Kinesis Stream <-> KCL applications (Geo enrichment ) <-> ES (Self build ) <-> Kibana 


