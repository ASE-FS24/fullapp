resource "aws_api_gateway_rest_api" "postmanager" {
  name        = "${var.postmanager_name}-api"
  description = "Nexusnet postmanager api using jar"
}

resource "aws_lambda_permission" "postmanager_rest_api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.postmanager_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.postmanager.execution_arn}/*/*"
}


resource "aws_api_gateway_resource" "postmanager" {
  parent_id   = aws_api_gateway_rest_api.postmanager.root_resource_id
  path_part   = var.api_path
  rest_api_id = aws_api_gateway_rest_api.postmanager.id
}

resource "aws_api_gateway_method" "postmanager" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.postmanager.id
  rest_api_id   = aws_api_gateway_rest_api.postmanager.id
}

resource "aws_api_gateway_integration" "postmanager" {
  http_method = aws_api_gateway_method.postmanager.http_method
  resource_id = aws_api_gateway_resource.postmanager.id
  rest_api_id = aws_api_gateway_rest_api.postmanager.id

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.postmanager_api.invoke_arn

}

resource "aws_api_gateway_deployment" "postmanager" {
  rest_api_id = aws_api_gateway_rest_api.postmanager.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.postmanager.id,
      aws_api_gateway_method.postmanager.id,
      aws_api_gateway_integration.postmanager.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "postmanager" {
  deployment_id = aws_api_gateway_deployment.postmanager.id
  rest_api_id   = aws_api_gateway_rest_api.postmanager.id
  stage_name    = "pm-${var.api_stage_name}"
}
