#!/bin/bash
# Check the ready hooks ran and created their resources:
# - 01-init-secrets.sh creates my-platform-secret from MY_SECRET_TOKEN_VALUE
# - 02-init-params.py creates the /my/param-1 and /my/param-2 parameters
set -euo pipefail

ENDPOINT=${ENDPOINT:-http://localhost:4566}
MAX_ATTEMPTS=${MAX_ATTEMPTS:-60}
export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=us-east-1

ready=""
for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  ready=$(curl -s "$ENDPOINT/_localstack/init/ready" || true)
  echo "$ready" | jq -e '.completed == true' > /dev/null 2>&1 && break
  echo "Attempt $attempt/$MAX_ATTEMPTS: ready hooks not finished"
  sleep 2
done
echo "$ready" | jq .
for script in 01-init-secrets.sh 02-init-params.py; do
  if ! echo "$ready" | jq -e --arg s "$script" 'any(.scripts[]; .name == $s and .state == "SUCCESSFUL")' > /dev/null; then
    echo "Test failed: ready hook $script did not succeed"
    exit 1
  fi
done
echo "PASS: both ready hooks succeeded"

secret=$(aws --endpoint-url "$ENDPOINT" secretsmanager get-secret-value --secret-id my-platform-secret \
  --query SecretString --output text)
if [[ "$secret" != *'hello-there'* ]]; then
  echo "Test failed: my-platform-secret is '$secret'"
  exit 1
fi
echo "PASS: secret created with the value from MY_SECRET_TOKEN_VALUE"

for param in "/my/param-1=my-param" "/my/param-2=my-other-param"; do
  value=$(aws --endpoint-url "$ENDPOINT" ssm get-parameter --name "${param%%=*}" --query Parameter.Value --output text)
  if [ "$value" != "${param#*=}" ]; then
    echo "Test failed: ${param%%=*} is '$value'"
    exit 1
  fi
done
echo "PASS: SSM parameters created"

echo "Test passed: the ready hooks seeded LocalStack"
