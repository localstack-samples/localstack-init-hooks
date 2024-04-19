Seeding LocalStack instances with init hooks
============================================

[Initialization hooks](https://docs.localstack.cloud/references/init-hooks/) are a way to automatically run scripts and programs during localstack lifecycle phases.
For instance, you could run a set of AWS commands after localstack has become ready to serve requests.

This sample shows how to use init hooks when using
* `docker compose` (`example-docker-compose/`)
* `localstack` cli (`example-localstack-cli/`)
