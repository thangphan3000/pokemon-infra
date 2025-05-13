#!/bin/bash

set -e

pushd production/ap-southeast-1/production
  terragrunt run-all plan
  terragrunt run-all apply
popd

: "${AWS_PROFILE:=production}"
: "${INVALIDATION_CACHE_PATH:=*}"
: "${BUCKET_NAME_KEYWORD:=pokemon}"

S3_BUCKET_NAME=$(aws s3 ls --profile "$AWS_PROFILE" | grep "$BUCKET_NAME_KEYWORD" | cut -d ' ' -f 3)

if  [ -z "$S3_BUCKET_NAME" ]; then
  echo "S3 bucket containing $S3_BUCKET_NAME not found in AWS profile '$AWS_PROFILE'. Exiting."
  exit 1
fi

aws s3 sync ./public "s3://$S3_BUCKET_NAME" --profile "$AWS_PROFILE"
echo "Successfully uploaded files to S3 bucket '$S3_BUCKET_NAME'"

CLOUDFRONT_DISTRIBUTION_ID=$(aws cloudfront list-distributions --profile "$AWS_PROFILE" | jq '.DistributionList.Items[].Id' | sed 's/"//g')

if [ -z "$CLOUDFRONT_DISTRIBUTION_ID" ]; then
    echo "CloudFront distribution not found for profile '$AWS_PROFILE'. Ensure a distribution is associated with the S3 bucket. Exiting."
    exit 1
fi

aws cloudfront create-invalidation --distribution-id "${CLOUDFRONT_DISTRIBUTION_ID}" --paths "/${INVALIDATION_CACHE_PATH}" --profile "$AWS_PROFILE"
echo "Invalidating CloudFront cache for distribution ID '$CLOUDFRONT_DISTRIBUTION_ID' with path: /$INVALIDATION_CACHE_PATH"
