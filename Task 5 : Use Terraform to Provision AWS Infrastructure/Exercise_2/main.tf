# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = ""
  secret_key = ""
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# package the function for python deployment
data "archive_file" "app_deployment_file" {
	type		= "zip"
	source_file	= "greet_lambda.py"
	output_path = "app.zip"
}


resource "aws_lambda_function" "lambda_udacity" {
  filename = "app.zip"
  function_name = "greet_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "greet_lambda.lambda_handler"
  runtime       = "python3.8"
  environment {
		variables = {
			greeting = "Hi there!"
		}
	}
}

resource "aws_cloudwatch_event_rule" "demo_lambda_every_one_minute" {
  name = "demo_lambda_every_one_minute"
  depends_on = [
    "aws_lambda_function.lambda_udacity"
  ]
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "lambda_udacity" {
  target_id = "lambda_udacity" 
  rule = "${aws_cloudwatch_event_rule.demo_lambda_every_one_minute.name}"
  arn = "${aws_lambda_function.lambda_udacity.arn}"
}

resource "aws_lambda_permission" "demo_lambda_every_one_minute" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_udacity.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.demo_lambda_every_one_minute.arn}"
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],      
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "udacity_logs" {
  name              = aws_lambda_function.lambda_udacity.function_name
  retention_in_days = 14
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}