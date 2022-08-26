<!-- BEGIN_TF_DOCS -->
# CodeBuild Project for integration with a CodePipeline

Creates a CodeBuild with supporting resources, including assuming an IAM Role and exporting the
credentials into the environment (this works around the default credentials for a CodeBuild
not being accessible within a container running Terraform).

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_iam_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifacts_bucket_arn"></a> [artifacts\_bucket\_arn](#input\_artifacts\_bucket\_arn) | ARN of the bucket for storing codepipeline artifacts | `string` | n/a | yes |
| <a name="input_build_commands"></a> [build\_commands](#input\_build\_commands) | Commands to run in the build phase | `list(any)` | `[]` | no |
| <a name="input_file_artifacts"></a> [file\_artifacts](#input\_file\_artifacts) | Files to list in the artefacts > files section of the buildspec. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the build | `string` | n/a | yes |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The ARN of the IAM role to assume for the build | `string` | `""` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for the builds to run inside a VPC. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project_arn"></a> [project\_arn](#output\_project\_arn) | The ARN of the CodeBuild project |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | The name of the CodeBuild Project |

## Development

Generation of this README and formatting of Terraform code is done via a Git pre-commit hook. To install run:

    scripts/install-hooks.sh

To run the tests you need to login to AWS (use the "Infra Testing" account) and run `./test.sh`.

Releases are published (after running the tests) by pushing a semver tag (e.g. `v1.2.3`).
<!-- END_TF_DOCS -->