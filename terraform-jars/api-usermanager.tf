resource "aws_api_gateway_rest_api" "usermanager" {
  name = "${var.usermanager_name}-api"
  description = "Nexusnet usermanager api using jar"
}

resource "aws_lambda_permission" "usermanager_rest_api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.usermanager_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.usermanager.execution_arn}/*/*"
}


resource "aws_api_gateway_resource" "usermanager" {
  parent_id   = aws_api_gateway_rest_api.usermanager.root_resource_id
  path_part   = "${var.api_path}"
  rest_api_id = aws_api_gateway_rest_api.usermanager.id
}

resource "aws_api_gateway_method" "usermanager" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.usermanager.id
  rest_api_id   = aws_api_gateway_rest_api.usermanager.id
}

resource "aws_api_gateway_integration" "usermanager" {
  http_method = aws_api_gateway_method.usermanager.http_method
  resource_id = aws_api_gateway_resource.usermanager.id
  rest_api_id = aws_api_gateway_rest_api.usermanager.id

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.usermanager_api.invoke_arn}"

}

resource "aws_api_gateway_deployment" "usermanager" {
  rest_api_id = aws_api_gateway_rest_api.usermanager.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.usermanager.id,
      aws_api_gateway_method.usermanager.id,
      aws_api_gateway_integration.usermanager.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Unfortunately the proxy resource cannot match an empty path at the root of the API.
# To handle that, a similar configuration must be applied to the root resource that is built in to the REST API object:
resource "aws_api_gateway_method" "usermanager_root" {
  rest_api_id   = aws_api_gateway_rest_api.usermanager.id
  resource_id   = aws_api_gateway_rest_api.usermanager.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "usermanager_root" {
  rest_api_id = aws_api_gateway_rest_api.usermanager.id
  resource_id = aws_api_gateway_method.usermanager_root.resource_id
  http_method = aws_api_gateway_method.usermanager_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.usermanager_api.invoke_arn}"
}


resource "aws_api_gateway_stage" "usermanager" {
  deployment_id = aws_api_gateway_deployment.usermanager.id
  rest_api_id   = aws_api_gateway_rest_api.usermanager.id
  stage_name    = "${var.api_stage_name}"
}