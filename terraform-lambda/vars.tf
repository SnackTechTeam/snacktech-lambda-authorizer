variable "regionDefault" {
  default = "us-east-1"
}

variable "projectName" {
  default = "snacktech"
}

variable "functionName" {
  default = "${var.projectName}-authorizer"  
}

variable "lambdaTimeout" {
  default = 1000  
}

variable "lambdaMemorySize" {
  default = 256  
}

variable "ecrRepositoryName" {}
variable "imageTag" {}

variable "dbHost" {}
variable "dbUser" {}
variable "dbPassword" {}
variable "dbName" {}

variable "lambdaEnvironmentVariables" {
  default = {
    DB_HOST = var.dbHost,
    DB_USER = var.dbUser,
    DB_PASSWORD = var.dbPassword,
    DB_NAME = var.dbName
  }
}
