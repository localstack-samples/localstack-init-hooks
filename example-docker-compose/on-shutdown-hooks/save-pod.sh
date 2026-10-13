#!/bin/bash

# export the state through the LocalStack API
# and save it into the localstack volume which is mounted into `./volume`.
curl -sf -o /var/lib/localstack/my-pod.zip http://localhost:4566/_localstack/pods/state
