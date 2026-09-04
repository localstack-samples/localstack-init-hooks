#!/bin/bash

aws --endpoint-url=http://localhost:4566 secretsmanager create-secret --name my-platform-secret
aws --endpoint-url=http://localhost:4566 secretsmanager put-secret-value --secret-id my-platform-secret --secret-string "{\"MY_TOKEN\": \"${MY_SECRET_TOKEN_VALUE}\"}"
aws --endpoint-url=http://localhost:4566 secretsmanager get-secret-value --secret-id my-platform-secret
