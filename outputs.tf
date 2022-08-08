output "project_name" {
  value       = aws_codebuild_project.default.name
  description = "The name of the CodeBuild Project"
}

output "project_arn" {
  value       = aws_codebuild_project.default.arn
  description = "The ARN of the CodeBuild project"
}