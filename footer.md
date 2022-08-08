## Development

Generation of this README and formatting of Terraform code is done via a Git pre-commit hook. To install run:

    scripts/install-hooks.sh

To run the tests you need to login to AWS (use the "Infra Testing" account) and run `./test.sh`.

Releases are published (after running the tests) by pushing a semver tag (e.g. `v1.2.3`).