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

# VPC Config
variable "vpc_config" {
  description = "Configuration for the builds to run inside a VPC."
  type        = any
  default     = {}
}


variable "build_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = <<-EOT
    Information about the compute resources the build project will use. Valid values: BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE, BUILD_GENERAL1_2XLARGE. 
    BUILD_GENERAL1_SMALL is only valid if type is set to LINUX_CONTAINER. When type is set to LINUX_GPU_CONTAINER, compute_type must be BUILD_GENERAL1_LARGE
  EOT

  validation {
    condition     = can(regex("^(BUILD_GENERAL1_SMALL|BUILD_GENERAL1_MEDIUM|BUILD_GENERAL1_LARGE|BUILD_GENERAL1_2XLARGE)$", var.build_compute_type))
    error_message = "Invalid Compute Type. Use one of the following : BUILD_GENERAL1_SMALL|BUILD_GENERAL1_MEDIUM|BUILD_GENERAL1_LARGE|BUILD_GENERAL1_2XLARGE"
  }
}

variable "build_image" {
  type        = string
  description = "Docker image to use for this build project."
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
}

variable "build_image_pull_credentials_type" {
  type        = string
  description = <<-EOT
    Type of credentials AWS CodeBuild uses to pull images in your build. Valid values: CODEBUILD, SERVICE_ROLE. 
    When you use a cross-account or private registry image, you must use SERVICE_ROLE credentials. 
    When you use an AWS CodeBuild curated image, you must use CodeBuild credentials. Defaults to CODEBUILD
  EOT
  default     = "CODEBUILD"
  validation {
    condition     = can(regex("^(CODEBUILD|SERVICE_ROLE)$", var.build_image_pull_credentials_type))
    error_message = "Invalid Build Image pull credentials type, use one of the following : \"CODEBUILD\", \"SERVICE_ROLE\"."
  }
}

variable "container_privileged_mode" {
  type        = bool
  default     = true
  description = "Whether to enable running the Docker daemon inside a Docker container."
}

variable "build_container_type" {
  type        = string
  default     = "LINUX_CONTAINER"
  description = "Type of build environment to use for related builds."

  validation {
    condition     = can(regex("^(LINUX_CONTAINER|LINUX_GPU_CONTAINER|WINDOWS_SERVER_2019_CONTAINER|ARM_CONTAINER)$", var.build_container_type))
    error_message = "Invalid container type. Please refer to AWS Docs for Codebuild."
  }
}