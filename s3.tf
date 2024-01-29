module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.0"

  bucket = var.name

  tags = var.tags
}