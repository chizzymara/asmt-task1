variable "image_name" {
  type        = string
  description = "Image name for docker file."
  default     = "Webapp_image"
}

variable "image_tag" {
  type        = string
  description = "Tag for docker file."
  default     = "latest"
}

variable "container_name" {
  type        = string
  description = "name of the container."
  default     = "asmt-1-cmba-container"
}

variable "vpc-id" {
  description = "exisiting vpc-id which will be associated with the loadbalancer"
  default     = "vpc-087b4e0167a2591a9"
}

variable "subnets-list" {
  type        = list(string)
  description = "subnet ids to be associated  with the load balancer"
  default     = ["subnet-04d9ba157b61c1802", "subnet-0c98e1819f7381e46"]
}
