module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.0.1"

  function_name = var.function_name
  description   = "Provisioner for RDS databases / users / groups / permissions"

  runtime     = "python3.11"
  handler     = "main.handler"
  source_path = "./function"

  tags = var.tags
}
