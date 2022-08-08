data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "build_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_iam_role" "build" {
  name_prefix        = "build-role"
  assume_role_policy = data.aws_iam_policy_document.build_assume_role_policy.json
}

resource "aws_iam_policy" "build" {
  name_prefix = "build"
  policy      = data.aws_iam_policy_document.build.json
}

data "aws_iam_policy_document" "build" {
  statement {
    effect = "Allow"
    actions = [
      "sts:GetCallerIdentity"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "build" {
  policy_arn = aws_iam_policy.build.arn
  role       = aws_iam_role.build.id
}

resource "aws_s3_bucket" "artifacts" {
  bucket_prefix = "artifacts"
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
