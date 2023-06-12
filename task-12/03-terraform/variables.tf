variable "instance_name" {
  description = "The name of the EC2 instances"
  type        = string
  default     = "web-server"
}

variable "instance_type" {
  description = "The type of EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "stage_name" {
  description = "The stage name"
  type        = string
  default     = "dev"
}
