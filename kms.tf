module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.1.0"

  aliases = [var.name]

  tags = var.tags
}