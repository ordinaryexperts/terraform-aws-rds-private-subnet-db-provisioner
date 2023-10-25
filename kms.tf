module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.0.1"

  aliases = [var.name]

  tags = var.tags
}