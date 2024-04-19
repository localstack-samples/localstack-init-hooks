#!/bin/bash

awslocal secretsmanager create-secret --name my-platform-secret
awslocal secretsmanager put-secret-value --secret-id my-platform-secret --secret-string "{\"MY_TOKEN\": \"${MY_SECRET_TOKEN_VALUE}\"}"
awslocal secretsmanager get-secret-value --secret-id my-platform-secret
