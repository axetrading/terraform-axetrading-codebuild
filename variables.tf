variable "name" {
  type        = string
  description = "Name of the build"
}

variable "artifacts_bucket_arn" {
  type        = string
  description = "ARN of the bucket for storing codepipeline artifacts"
}

variable "build_commands" {
  type        = list(any)
  description = "Commands to run in the build phase"
  default     = []
}

variable "role_arn" {
  type        = string
  description = "The ARN of the IAM role to assume for the build"
  default     = ""
}

variable "file_artifacts" {
  type        = list(string)
  description = "Files to list in the artefacts > files section of the buildspec."
  default     = []
}
