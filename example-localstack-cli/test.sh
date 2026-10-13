#!/bin/bash
# Check the init-vpc.sh ready hook mounted through .lstk/config.toml ran and
# created the VPC with its three tagged subnets.
set -euo pipefail

ENDPOINT=${ENDPOINT:-http://localhost:4566}
MAX_ATTEMPTS=${MAX_ATTEMPTS:-60}
VPC_NAME=${VPC_NAME:-MyVPC}

ready=""
for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  ready=$(curl -s "$ENDPOINT/_localstack/init/ready" || true)
  echo "$ready" | jq -e '.completed == true' > /dev/null 2>&1 && break
  echo "Attempt $attempt/$MAX_ATTEMPTS: ready hooks not finished"
  sleep 2
done
echo "$ready" | jq .
if ! echo "$ready" | jq -e 'any(.scripts[]; .name == "init-vpc.sh" and .state == "SUCCESSFUL")' > /dev/null; then
  echo "Test failed: ready hook init-vpc.sh did not succeed"
  exit 1
fi
echo "PASS: init-vpc.sh succeeded"

vpc_id=$(lstk aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$VPC_NAME" --query 'Vpcs[0].VpcId' --output text)
if [ -z "$vpc_id" ] || [ "$vpc_id" = "None" ]; then
  echo "Test failed: no VPC tagged Name=$VPC_NAME"
  exit 1
fi
echo "PASS: found VPC $vpc_id"

subnets=$(lstk aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$vpc_id" "Name=tag:aws-cdk:subnet-type,Values=Isolated" \
  --query 'length(Subnets)' --output text)
if [ "$subnets" != "3" ]; then
  echo "Test failed: expected 3 isolated subnets in $vpc_id, found $subnets"
  exit 1
fi
echo "PASS: VPC has 3 isolated subnets"

echo "Test passed: the init hook created the VPC"
