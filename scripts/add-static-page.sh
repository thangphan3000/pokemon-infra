#!/bin/bash

set -e

: "${AWS_PROFILE:=production}"

S3_BUCKET_NAME=$(aws s3 ls --profile "$AWS_PROFILE" | grep pokemon | cut -d ' ' -f 3)

aws s3 sync ../public "s3://$S3_BUCKET_NAME" --profile "$AWS_PROFILE"

echo "Added pokemon's static frontend page"
