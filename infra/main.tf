# =============================================================================
# Datadog Monitors Infrastructure
# =============================================================================

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.0"
    }
  }
  
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://api.${var.datadog_site}/"
}

# =============================================================================
# Locals
# =============================================================================

locals {
  monitors_path = "${path.module}/../monitors/${var.environment}"
  monitor_files = fileset(local.monitors_path, "*.json")
  
  monitors = {
    for file in local.monitor_files :
    trimsuffix(file, ".json") => jsondecode(file("${local.monitors_path}/${file}"))
  }
}

# =============================================================================
# Monitors
# =============================================================================

resource "datadog_monitor" "monitors" {
  for_each = local.monitors
  
  name    = each.value.name
  type    = each.value.type
  query   = each.value.query
  message = each.value.message
  
  tags = concat(
    lookup(each.value, "tags", []),
    ["env:${var.environment}", "managed-by:terraform"]
  )
  
  monitor_thresholds {
    critical          = lookup(lookup(each.value, "options", {}), "thresholds", {}).critical
    warning           = lookup(lookup(lookup(each.value, "options", {}), "thresholds", {}), "warning", null)
    critical_recovery = lookup(lookup(lookup(each.value, "options", {}), "thresholds", {}), "critical_recovery", null)
    warning_recovery  = lookup(lookup(lookup(each.value, "options", {}), "thresholds", {}), "warning_recovery", null)
  }
  
  notify_no_data    = lookup(lookup(each.value, "options", {}), "notify_no_data", false)
  renotify_interval = lookup(lookup(each.value, "options", {}), "renotify_interval", 0)
  
  include_tags        = lookup(lookup(each.value, "options", {}), "include_tags", true)
  require_full_window = lookup(lookup(each.value, "options", {}), "require_full_window", true)
  
  priority = lookup(each.value, "priority", null)
}

# =============================================================================
# Outputs
# =============================================================================

output "monitors_created" {
  description = "Lista de monitors criados"
  value = {
    for k, v in datadog_monitor.monitors : k => {
      id   = v.id
      name = v.name
      type = v.type
    }
  }
}

output "monitor_count" {
  description = "Quantidade de monitors criados"
  value       = length(datadog_monitor.monitors)
}
