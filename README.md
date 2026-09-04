Seeding LocalStack instances with init hooks
============================================

[Initialization hooks](https://docs.localstack.cloud/references/init-hooks/) are a way to automatically run scripts and programs during localstack lifecycle phases.
For instance, you could run a set of AWS commands after localstack has become ready to serve requests.

This sample shows how to use init hooks when using
* `docker compose` (`example-docker-compose/`)
* `lstk` (`example-localstack-cli/`)

## Prerequisites

- A valid [LocalStack for AWS license](https://localstack.cloud/pricing). Your license provides a [`LOCALSTACK_AUTH_TOKEN`](https://docs.localstack.cloud/aws/getting-started/auth-token/) to activate LocalStack.
- [`lstk`](https://docs.localstack.cloud/aws/developer-tools/running-localstack/lstk/). Install it with `npm install -g @localstack/lstk`, or `brew install localstack/tap/lstk`.
- [Docker Compose](https://docs.docker.com/compose/install/).
- [AWS CLI](https://docs.localstack.cloud/user-guide/integrations/aws-cli/), required by `lstk aws`.

