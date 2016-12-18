#!/bin/bash

# Ref: http://docs.aws.amazon.com/cli/latest/reference/kinesis/index.html

# List streams
aws kinesis list-streams

# Describe 
aws kinesis describe-stream --stream-name stream-s3

# Create kinesis stream weblog-stream
aws kinesis create-stream --stream-name weblog-stream --shard-count 1
