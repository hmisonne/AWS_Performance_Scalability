# TODO: Define the output variable for the lambda function.

output "lambda_arn"{
    description = "ARN of Udacity Lambda Function"
    value = "${aws_lambda_function.lambda_udacity.arn}"
}