// terraform/variables.tf

variable "resource_group_name" {
  description = "The name of the resource group to create."
  type        = string
  default     = "my-resource-group"
}

variable "location" {
  description = "The location/region where the resources will be deployed."
  type        = string
  default     = "West US"
}

variable "event_hub_namespace_name" {
  description = "The name of the Event Hubs namespace."
  type        = string
  default     = "my-event-hub-ns"
}

variable "event_hub_name" {
  description = "The name of the Event Hub instance."
  type        = string
  default     = "my-event-hub"
}

variable "notification_hub_namespace_name" {
  description = "The name of the Notification Hubs namespace."
  type        = string
  default     = "my-notification-hub-ns"
}

variable "notification_hub_name" {
  description = "The name of the Notification Hub instance."
  type        = string
  default     = "my-notification-hub"
}

variable "container_instance_name" {
  description = "The name of the container instance to deploy."
  type        = string
  default     = "my-container-instance"
}

variable "container_image" {
  description = "The container image to deploy in the container instance."
  type        = string
  default     = "nginx:latest"
}

variable "container_cpu" {
  description = "The number of CPU cores to allocate to the container instance."
  type        = number
  default     = 1
}

variable "container_memory" {
  description = "The amount of memory to allocate to the container instance in GB."
  type        = number
  default     = 1.5
}

variable "admin_username" {
  description = "The admin username for accessing resources."
  type        = string
}

variable "admin_password" {
  description = "The admin password for accessing resources."
  type        = string
  sensitive   = true
}

variable "environment_variables" {
  description = "A map of key-value pairs for environment variables to set in the container instance."
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace used for monitoring the container instance."
  type        = string
  default     = ""
}

variable "log_analytics_workspace_key" {
  description = "The key of the Log Analytics workspace used for monitoring the container instance."
  type        = string
  sensitive   = true
  default     = ""
}
