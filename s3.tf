module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.0.1"

  bucket = var.name

  tags = var.tags
}