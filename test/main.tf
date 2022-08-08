resource "random_id" "name" {
  prefix      = "codebuild-test-"
  byte_length = 8
}

module "test" {
  source               = "../"
  name                 = random_id.name.hex
  role_arn             = aws_iam_role.build.arn
  artifacts_bucket_arn = aws_s3_bucket.artifacts.arn
  build_commands = [
    "echo hello world",
    "aws sts get-caller-identity"
  ]
}
