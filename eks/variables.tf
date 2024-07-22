variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster"
}

variable "cluster_version" {
  type        = string
  description = "EKS version - matches with kubectl"
  default     = "1.30"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "A list of private subnet ids"
}

variable "vpc_id" {
  type        = string
  description = "private VPC id"
}