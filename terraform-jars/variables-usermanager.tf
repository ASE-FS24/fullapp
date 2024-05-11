####### Usermanager Variables #######
variable "usermanager_name" {
  default = "usermanager-jar2"
}

variable "usermanager_jar_loc" {
  default = "../user-manager/target"
}

variable "usermanager_jar" {
  default = "original-usermanager.jar"
}

variable "um_lambda_function_handler" {
  default = "ch.nexusnet.usermanager.aws.LambdaHandler::handleRequest"
}
