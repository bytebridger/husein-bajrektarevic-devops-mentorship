variable "vpc_id" {
  description = "VPC used for task-12 solution"
  type        = string
  default     = "vpc-0ea7a88b3818e57f7"  # VPC ID
}

variable "my_subnets" {
  description = "Subnet used for task-12 solution (eu-central-1a)"
  type        = string
  default     = "subnet-0f2293bbca5229391"  # subnet ID
}

variable "ami_id" {
  description = "AMI used for task-12 solution"
  type        = string
  default     = "ami-041dc559818ef6e9b" # AMI ID  
}

variable "instance_name" {
  description = "The name of the EC2 instances"
  type        = string
  default     = "web-server"
}

variable "instance_type" {
  description = "Type of EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "stage_name" {
  description = "The stage name"
  type        = string
  default     = "dev"
}
