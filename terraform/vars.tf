variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}

variable "min_size" {
  description = "Min number of EC2 instances"
  default = 2
}

variable "max_size" {
  description = "Max number of EC2 instances"
  default = 4
}