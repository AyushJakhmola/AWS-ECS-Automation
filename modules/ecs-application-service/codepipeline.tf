# code pipeline

resource "aws_codepipeline" "code_pipeline" {
  count = var.enable_cicd ? 1 : 0
  name       = format("%s-%s-codepipeline", var.env, var.container_name)  
  role_arn   = aws_iam_role.codepipeline_role[0].arn

  artifact_store {
    location = var.s3_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      input_artifacts  = []
      output_artifacts = ["SourceArtifact"]

      configuration = {
        # Owner      = var.github_owner
        ConnectionArn    = aws_codestarconnections_connection.code_pipeline_connection[0].arn
        FullRepositoryId       = var.repo_name
        BranchName     = var.branch_name
        # OAuthToken = var.github_token
      }
    }
  }
  stage {
    name = "Build"

    action {
      category = "Build"

      input_artifacts = [
        "SourceArtifact",
      ]
      name = "Build"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
      configuration = {
        ProjectName = format("%s-%s-codebuild", var.env, var.container_name)
      }
    }
  }
  stage {
    name = "Deploy"

    action {
      category = "Deploy"
      configuration = {
        "ClusterName" = var.cluster_name
        "ServiceName" = var.task_definition_name
        "FileName"    = "imageDefinitions.json"
        #"DeploymentTimeout" = "15"
      }
      input_artifacts = [
        "BuildArtifact",
      ]
      name             = "App_Deploy"
      output_artifacts = []
      owner            = "AWS"
      provider         = "ECS"
      run_order        = 1
      version          = "1"
    }
  }
}

resource "aws_codestarconnections_connection" "code_pipeline_connection" {
  count = var.enable_cicd ? 1 : 0
  name          = "codebuild-connection"
  provider_type = "GitHub"
}
