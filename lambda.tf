/*
module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.0.1"

  function_name = var.name
  description   = "Provisioner for RDS databases / users / groups / permissions"

  runtime = "python3.11"
  handler = "main.handler"

  local_existing_package = data.archive_file.lambda_function.output_path

  vpc_subnet_ids         = var.subnet_ids
  vpc_security_group_ids = var.security_group_ids

  layers = [
    module.deps.lambda_layer_arn,
  ]

  tags = var.tags
}

module "deps" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.0.1"

  create_layer = true

  layer_name          = "${var.name}-deps"
  description         = "Dependencies for ${var.name}"
  compatible_runtimes = ["python3.11"]

  local_existing_package = "${path.module}/lambda_deps.zip"

  store_on_s3 = false
  #  s3_bucket   = "my-bucket-id-with-lambda-builds"
}
*/