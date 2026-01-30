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

# Monitor de CPU
resource "datadog_monitor" "cpu_high" {
  name    = "[${upper(var.environment)}] 🔥 ALERTA: CPU Elevada"
  type    = "metric alert"
  query   = "avg(last_5m):avg:system.cpu.user{env:${var.environment}} by {host} > 80"
  message = "CPU acima de 80% no host {{host.name}}. @foconapraticaoficial@gmail.com"
  
  tags = ["env:${var.environment}", "managed-by:terraform"]
  
  monitor_thresholds {
    critical = 80
    warning  = 60
  }
}

# Monitor de Memória
resource "datadog_monitor" "memory_high" {
  name    = "[${upper(var.environment)}] ⚠️ ALERTA: Memória Baixa"
  type    = "metric alert"
  query   = "avg(last_5m):avg:system.mem.pct_usable{env:${var.environment}} by {host} < 15"
  message = "Memória disponível abaixo de 15% no host {{host.name}}. @foconapraticaoficial@gmail.com"
  
  tags = ["env:${var.environment}", "managed-by:terraform"]
  
  monitor_thresholds {
    critical = 15
    warning  = 25
  }
}

# Monitor de Disco
resource "datadog_monitor" "disk_high" {
  name    = "[${upper(var.environment)}] 💾 ALERTA: Disco Cheio"
  type    = "metric alert"
  query   = "avg(last_5m):avg:system.disk.in_use{env:${var.environment}} by {host,device} * 100 > 80"
  message = "Disco acima de 80% no host {{host.name}}. @foconapraticaoficial@gmail.com"
  
  tags = ["env:${var.environment}", "managed-by:terraform"]
  
  monitor_thresholds {
    critical = 80
    warning  = 70
  }
}

output "monitors" {
  value = {
    cpu    = datadog_monitor.cpu_high.id
    memory = datadog_monitor.memory_high.id
    disk   = datadog_monitor.disk_high.id
  }
}
