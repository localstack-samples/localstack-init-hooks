# Using init hooks with the LocalStack CLI

Very simple example on how you can mount an init hook into the container using the CLI.

The `init-vpc.sh` script could be executed on the host after localstack has started, but can also be mounted into `/etc/localstack/init/ready.d` using the `-v` flag of `localstack`.

You can overwrite variables in the script by passing environment variables to the localstack container with the `-e` flag.

## Starting localstack

Start localstack by mounting the script into the `ready.d` init hook folder.

```console
localstack start -v ./init-vpc.sh:/etc/localstack/init/ready.d/init-vpc.sh
```

Overwrite environment variables if you want:


```console
localstack start -v ./init-vpc.sh:/etc/localstack/init/ready.d/init-vpc.sh \
	-e VPC_NAME="MyVpc" \
	-e VPC_CIDR="172.16.0.0/16" \
	-e SUBNET_1_CIDR="172.16.1.0/24" \
	-e SUBNET_2_CIDR="172.16.2.0/24" \
	-e SUBNET_3_CIDR="172.16.3.0/24"
```

## Check that stage was executed

You can check that the stage was executed successfully:

```console
% curl -s localhost:4566/_localstack/init/ready | jq 
{
  "completed": true,
  "scripts": [
    {
      "stage": "READY",
      "name": "init-vpc.sh",
      "state": "SUCCESSFUL"
    }
  ]
}
```
