#!/bin/bash
set -eo pipefail

# Init hooks do not inherit AWS settings, so default to the LocalStack test credentials
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-east-1}
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-test}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-test}

aws --endpoint-url=http://localhost:4566 secretsmanager create-secret --name my-platform-secret
aws --endpoint-url=http://localhost:4566 secretsmanager put-secret-value --secret-id my-platform-secret --secret-string "{\"MY_TOKEN\": \"${MY_SECRET_TOKEN_VALUE}\"}"
aws --endpoint-url=http://localhost:4566 secretsmanager get-secret-value --secret-id my-platform-secret
