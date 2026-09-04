# Using init hooks with lstk

Very simple example on how you can mount an init hook into the container using `lstk`.

The `init-vpc.sh` script could be executed on the host after localstack has started, but can also be mounted into `/etc/localstack/init/ready.d` via [`.lstk/config.toml`](.lstk/config.toml).

You can overwrite variables in the script by adding them to an `[env.default]` table in `.lstk/config.toml`.

## Starting localstack

Start localstack from this directory; `lstk` reads the init hook mount from `.lstk/config.toml`.

```console
export LOCALSTACK_AUTH_TOKEN=<your-auth-token> 
lstk start
```

Overwrite environment variables if you want, by adding them to `.lstk/config.toml`:

```toml
env = ["default"]

[env.default]
VPC_NAME = "MyVpc"
VPC_CIDR = "172.16.0.0/16"
SUBNET_1_CIDR = "172.16.1.0/24"
SUBNET_2_CIDR = "172.16.2.0/24"
SUBNET_3_CIDR = "172.16.3.0/24"
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
