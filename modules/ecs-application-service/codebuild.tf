resource "aws_codebuild_project" "codebuild_app" {
  count = var.enable_cicd ? 1 : 0
  name          = format("%s-%s-codebuild", var.env, var.container_name)  
  description   = "codebuild project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role[0].arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    buildspec = "${var.container_name}/buildspec.yml"
    type            = "GITHUB"
    location        = var.repo_location
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }
}