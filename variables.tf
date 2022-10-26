variable "region" {
  default = "us-west-2"
}

variable "key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "db_username" {
  default = "postgres"
}

variable "db_password" {
  default = "foobarbaz"
}

variable "app_image_id" {
  default = "ami-0d593311db5abb72b"
}
