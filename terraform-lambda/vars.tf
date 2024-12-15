variable "regionDefault" {
  default = "us-east-1"
}

variable "projectName" {
  default = "snacktech"
}

variable "lambdaTimeout" {
  default = 300
}

variable "lambdaMemorySize" {
  default = 256  
}

variable "imageUri" {}

variable "lambdaEnvironmentVariables" {
  type = map(string)
}
