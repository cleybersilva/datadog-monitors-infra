terraform {
  required_version = ">= 1.0"
  
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.0"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://api.${var.datadog_site}/"
}

# Referência aos monitors existentes (criados via API)
# IDs: CPU=17789464, Memory=17789465, Disk=17789463

# Novos monitors podem ser adicionados abaixo
# Os monitors básicos já existem no Datadog, gerenciados via API

output "existing_monitors" {
  value = {
    cpu    = "17789464"
    memory = "17789465"
    disk   = "17789463"
  }
  description = "IDs dos monitors existentes gerenciados via API"
}

# Adicione novos monitors aqui se necessário
# resource "datadog_monitor" "new_monitor" { ... }
