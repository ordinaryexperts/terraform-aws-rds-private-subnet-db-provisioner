module "docker_image" {
  source  = "terraform-aws-modules/lambda/aws//modules/docker-build"
  version = "6.0.1"

  create_ecr_repo = true
  ecr_repo        = var.name

  ecr_repo_lifecycle_policy = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Keep only the last 2 images",
        "selection" : {
          "tagStatus" : "any",
          "countType" : "imageCountMoreThan",
          "countNumber" : 2
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })

  image_tag   = "foo"
  source_path = "function"
  build_args = {
    FOO = "bar"
  }
  platform = "linux/amd64"
}
