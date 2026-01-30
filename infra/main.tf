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

# Monitor de Apache
resource "datadog_monitor" "apache_down" {
  name    = "[${upper(var.environment)}] 🌐 Apache Down"
  type    = "service check"
  query   = "\"apache.can_connect\".over(\"env:${var.environment}\").by(\"host\").last(3).count_by_status()"
  message = "Apache não está respondendo no host {{host.name}}! @foconapraticaoficial@gmail.com"
  
  tags = ["env:${var.environment}", "managed-by:terraform", "service:apache"]
  
  monitor_thresholds {
    critical = 3
    warning  = 1
  }
}

# Monitor de Docker Containers
resource "datadog_monitor" "container_down" {
  name    = "[${upper(var.environment)}] 🐳 Container Stopped"
  type    = "query alert"
  query   = "avg(last_5m):sum:docker.containers.running{env:${var.environment}} < 10"
  message = "Número de containers rodando menor que 10! Verificar se há containers parados. @foconapraticaoficial@gmail.com"
  
  tags = ["env:${var.environment}", "managed-by:terraform", "service:docker"]
  
  monitor_thresholds {
    critical = 10
    warning  = 15
  }
}

# Monitor de HTTP Check - N8N
resource "datadog_monitor" "n8n_health" {
  name    = "[${upper(var.environment)}] ⚙️ N8N Unhealthy"
  type    = "service check"
  query   = "\"http.can_connect\".over(\"env:${var.environment}\",\"instance:n8n\").by(\"host\").last(3).count_by_status()"
  message = "N8N não está respondendo! @foconapraticaoficial@gmail.com"
  
  tags = ["env:${var.environment}", "managed-by:terraform", "service:n8n"]
  
  monitor_thresholds {
    critical = 3
    warning  = 1
  }
}

# Monitor de Network Errors
resource "datadog_monitor" "network_errors" {
  name    = "[${upper(var.environment)}] 🌐 Network Errors High"
  type    = "query alert"
  query   = "avg(last_5m):sum:system.net.errors_in{env:${var.environment}} by {host} + sum:system.net.errors_out{env:${var.environment}} by {host} > 100"
  message = "Alto número de erros de rede no host {{host.name}}! @foconapraticaoficial@gmail.com"
  
  tags = ["env:${var.environment}", "managed-by:terraform", "service:network"]
  
  monitor_thresholds {
    critical = 100
    warning  = 50
  }
}
# Managed by Terraform - Fri Jan 30 22:14:50 UTC 2026
