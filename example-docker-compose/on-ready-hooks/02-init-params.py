import os
import boto3

os.environ["AWS_ENDPOINT_URL"] = "http://localhost:4566"
os.environ["AWS_DEFAULT_REGION"] = "us-east-1"

ssm = boto3.client("ssm")

# list of parameters to add
parameters = {
	"/my/param-1": "my-param",
	"/my/param-2": "my-other-param",
}

# iterate over all parameters and add them
for k,v in parameters.items():
	ssm.put_parameter(Name=k, Value=v, Type="String")
