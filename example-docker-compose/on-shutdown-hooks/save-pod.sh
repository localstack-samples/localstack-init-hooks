#!/bin/bash

# use the localstack CLI within the container
# and save the state it into the localstack volume which is mounted into `./volume`.
/opt/code/localstack/.venv/bin/localstack state export /var/lib/localstack/my-pod.zip
