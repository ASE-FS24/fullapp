####### Postmanager Variables #######
variable "postmanager_name" {
  default = "postmanager-jar2"
}

variable "postmanager_jar_loc" {
  default = "../post-manager/target"
}

variable "postmanager_jar" {
  default = "original-postmanager.jar"
}

variable "pm_lambda_function_handler" {
  default = "ch.nexusnet.postmanager.aws.LambdaHandler::handleRequest"
}
