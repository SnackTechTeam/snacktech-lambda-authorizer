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

variable "imageUri" {
  default = "xxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com/ecr-snacktech-infra-authorizer:xxxxxxxxxx"
}

variable "lambdaEnvironmentVariables" {
  type = map(string)
  default = {
    RDS_HOST = "snacktech-db.xxxxxxxxx.us-east-1.rds.amazonaws.com"
    DB_NAME = "SnackTech"
    DB_USER = "XXXXXXXXX"
    DB_PASSWORD = "XXXXXXXXX"
  }
}

variable "serviceEndpoint" {
  type = string
  default = "XXXXXXXXXXXXXXXXXXXXXXXX"
}
