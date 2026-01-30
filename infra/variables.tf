variable "datadog_api_key" {
  description = "Datadog API Key"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog Application Key"
  type        = string
  sensitive   = true
}

variable "datadog_site" {
  description = "Datadog Site (us5.datadoghq.com, datadoghq.com, etc)"
  type        = string
  default     = "us5.datadoghq.com"
}

variable "environment" {
  description = "Environment (dev, hom, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "hom", "prod"], var.environment)
    error_message = "Environment must be dev, hom, or prod."
  }
}

variable "notification_channels" {
  description = "Canais de notificação padrão"
  type        = list(string)
  default     = []
}
