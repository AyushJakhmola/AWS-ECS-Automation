module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = format("%s-%s-repo", var.env, var.container_name)
  repository_image_tag_mutability = "MUTABLE"
  repository_force_delete = true

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection = {
          tagStatus     = "any",
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Name = format("%s-%s-repo", var.env, var.container_name)
    Environment = var.env
  }
}
