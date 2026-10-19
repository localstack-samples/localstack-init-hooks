#!/bin/bash

# export the state through the LocalStack API
# and save it into the localstack volume which is mounted into `./volume`.
# The LocalStack image does not ship curl, so use its Python.
python3 - <<'PY'
import urllib.request

opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))
with opener.open("http://localhost:4566/_localstack/pods/state") as response:
    with open("/var/lib/localstack/my-pod.zip", "wb") as pod:
        pod.write(response.read())
PY
