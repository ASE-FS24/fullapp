resource "aws_api_gateway_rest_api" "chatmanager" {
  name        = "${var.chatmanager_name}-api"
  description = "Nexusnet chatmanager api using jar"
}

resource "aws_lambda_permission" "chatmanager_rest_api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chatmanager_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.chatmanager.execution_arn}/*/*"
}


resource "aws_api_gateway_resource" "chatmanager" {
  parent_id   = aws_api_gateway_rest_api.chatmanager.root_resource_id
  path_part   = var.api_path
  rest_api_id = aws_api_gateway_rest_api.chatmanager.id
}

resource "aws_api_gateway_method" "chatmanager" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.chatmanager.id
  rest_api_id   = aws_api_gateway_rest_api.chatmanager.id
}

resource "aws_api_gateway_integration" "chatmanager" {
  http_method = aws_api_gateway_method.chatmanager.http_method
  resource_id = aws_api_gateway_resource.chatmanager.id
  rest_api_id = aws_api_gateway_rest_api.chatmanager.id

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.chatmanager_api.invoke_arn

}

resource "aws_api_gateway_deployment" "chatmanager" {
  rest_api_id = aws_api_gateway_rest_api.chatmanager.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.chatmanager.id,
      aws_api_gateway_method.chatmanager.id,
      aws_api_gateway_integration.chatmanager.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "chatmanager" {
  deployment_id = aws_api_gateway_deployment.chatmanager.id
  rest_api_id   = aws_api_gateway_rest_api.chatmanager.id
  stage_name    = "cm-${var.api_stage_name}"
}
