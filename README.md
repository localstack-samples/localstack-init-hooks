Seeding LocalStack instances with init hooks
============================================

[Initialization hooks](https://docs.localstack.cloud/references/init-hooks/) are a way to automatically run scripts and programs during localstack lifecycle phases.
For instance, you could run a set of AWS commands after localstack has become ready to serve requests.

This sample shows how to use init hooks when using
* `docker compose` (`example-docker-compose/`)
* `localstack` cli (`example-localstack-cli/`)

## Prerequisites

- A valid [LocalStack for AWS license](https://localstack.cloud/pricing). Your license provides a [`LOCALSTACK_AUTH_TOKEN`](https://docs.localstack.cloud/getting-started/auth-token/) to activate LocalStack.
- [`localstack` CLI](https://docs.localstack.cloud/getting-started/installation/#localstack-cli).
- [Docker Compose](https://docs.docker.com/compose/install/).
- [AWS CLI](https://docs.localstack.cloud/user-guide/integrations/aws-cli/) with the [`awslocal` wrapper](https://docs.localstack.cloud/user-guide/integrations/aws-cli/#localstack-aws-cli-awslocal).

## Start LocalStack

Start LocalStack with the `LOCALSTACK_AUTH_TOKEN` pre-configured:

```bash
export LOCALSTACK_AUTH_TOKEN=<your-auth-token>
make start
make ready
```
