####### Chatmanager Variables #######
variable "chatmanager_name" {
  default = "chatmanager-jar2"
}

variable "chatmanager_jar_loc" {
  default = "../chat-manager/target"
}

variable "chatmanager_jar" {
  default = "original-chatmanager.jar"
}

variable "cm_lambda_function_handler" {
  default = "ch.nexusnet.chatmanager.aws.lambda.LambdaHandler::handleRequest"
  #/root/fullapp/chat-manager/src/main/java/ch/nexusnet/chatmanager/aws/lambda/LambdaHandler.java
}
