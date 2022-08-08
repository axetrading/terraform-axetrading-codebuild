/**
 * # CodeBuild Project for integration with a CodePipeline
 *
 * Creates a CodeBuild with supporting resources, including assuming an IAM Role and exporting the
 * credentials into the environment (this works around the default credentials for a CodeBuild
 * not being accessible within a container running Terraform). 
 */

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_policy" "default" {
  name   = var.name
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  statement {
    effect    = "Allow"
    resources = ["${aws_cloudwatch_log_group.default.arn}:*"]
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
  }
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [var.artifacts_bucket_arn]
    effect    = "Allow"
  }
  statement {
    actions   = ["s3:*"]
    resources = ["${var.artifacts_bucket_arn}/*"]
    effect    = "Allow"
  }
  statement {
    actions   = ["sts:AssumeRole"]
    resources = [var.role_arn]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  policy_arn = aws_iam_policy.default.arn
  role       = aws_iam_role.default.name
}

resource "aws_codebuild_project" "default" {
  badge_enabled  = false
  build_timeout  = 20
  name           = var.name
  queued_timeout = 60
  service_role   = aws_iam_role.default.arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type = "CODEPIPELINE"
    buildspec = yamlencode({
      version = "0.2",
      phases = {
        install = { commands = [
          "creds=$(aws sts assume-role --role-arn \"${var.role_arn}\" --role-session-name \"${var.name}-code-build\")",
          "export AWS_ACCESS_KEY_ID=$(echo \"$creds\" | jq -r '.Credentials.AccessKeyId')",
          "export AWS_SECRET_ACCESS_KEY=$(echo \"$creds\" | jq -r '.Credentials.SecretAccessKey')",
          "export AWS_SESSION_TOKEN=$(echo \"$creds\" | jq -r '.Credentials.SessionToken')"
        ] },
        build = { commands = var.build_commands }
      },
      artifacts = { files = var.file_artifacts }
    })
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.default.name
    }
  }
}

resource "aws_cloudwatch_log_group" "default" {
  name_prefix       = var.name
  retention_in_days = 180
}
