# Using init hooks with docker compose

This example has two scripts that are executed as soon as localstack is ready:

* a shell script that creates a secretsmanager secret based with a value set from an environment variable
* a python script that creates parameters based on a list of values defined in the script

And one script that runs when localstack shuts down:
* a shell script that saves the state into `./volume/my-pod.zip` before localstack shuts down

## Start LocalStack

```console
LOCALSTACK_AUTH_TOKEN=ls-... docker compose up
```

## Check that the ready stage is completed:

```console
% curl -s localhost:4566/_localstack/init/ready | jq 
{
  "completed": true,
  "scripts": [
    {
      "stage": "READY",
      "name": "01-init-secrets.sh",
      "state": "SUCCESSFUL"
    },
    {
      "stage": "READY",
      "name": "02-init-params.py",
      "state": "SUCCESSFUL"
    }
  ]
}
```

## Check that resources were created

### Secretsmanager secrets (Shell script)

```console
 % awslocal secretsmanager get-secret-value --secret-id my-platform-secret
{
    "ARN": "arn:aws:secretsmanager:us-east-1:000000000000:secret:my-platform-secret-BlLPzn",
    "Name": "my-platform-secret",
    "VersionId": "c6bf77b5-1d4e-4b23-839e-250b747fe818",
    "SecretString": "{\"MY_TOKEN\": \"\"hello-there\"\"}",
    "VersionStages": [
        "AWSCURRENT"
    ],
    "CreatedDate": 1713548877.0
}
```


### SSM Parameters (Python script)

```console
awslocal ssm describe-parameters
{
    "Parameters": [
        {
            "Name": "/my/param-1",
            "Type": "String",
            "LastModifiedDate": 1713548879.229,
            "LastModifiedUser": "N/A",
            "Version": 1,
            "DataType": "text"
        },
        {
            "Name": "/my/param-2",
            "Type": "String",
            "LastModifiedDate": 1713548879.309,
            "LastModifiedUser": "N/A",
            "Version": 1,
            "DataType": "text"
        }
    ]
}
```

```console
awslocal ssm get-parameter --name "/my/param-1"
{
    "Parameter": {
        "Name": "/my/param-1",
        "Type": "String",
        "Value": "my-param",
        "Version": 1,
        "LastModifiedDate": 1713548879.229,
        "ARN": "arn:aws:ssm:us-east-1:000000000000:parameter/my/param-1",
        "DataType": "text"
    }
}

```

## Shutdown

After you've shut down localstack, you should see a zipfile `my-pod.zip` in `./volume`, which is created by the shutdown hook.
This is a state export that you can import into a fresh localstack instance with `localstack state import <...>`.
