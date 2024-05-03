####### Usermanager Variables #######
variable "usermanager_name" {
   default = "usermanager-jar"
}

variable "usermanager_jar_loc" {
  default = "./jars"
}

variable "usermanager_jar" {
  default = "original-usermanager.jar"  
}

variable "um_lambda_function_handler" {
  default = "ch.nexusnet.usermanager.aws.LambdaHandler::handleRequest"
}