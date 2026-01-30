# 🐕 Datadog Monitors Infrastructure

Este repositório contém a infraestrutura necessária para provisionar monitors no Datadog utilizando Terraform. Os monitors são organizados por ambiente (dev, hom, prod) e configurados para monitorar diversos serviços e aplicações.

## 📁 Estrutura do Projeto

```
├── .github/
│   └── workflows/          # Workflows do GitHub Actions para CI/CD
├── infra/                  # Arquivos Terraform (configuração de infraestrutura e provisionamento)
├── inventories/            # Inventários de configuração por ambiente
├── monitors/               # Arquivos JSON que definem os monitors, separados por ambiente
│   ├── dev/               # Monitors para ambiente de desenvolvimento
│   ├── hom/               # Monitors para ambiente de homologação
│   └── prod/              # Monitors para ambiente de produção
├── tests/                  # Arquivos de configuração de testes automatizados
└── docs/                   # Documentação dos monitors
```

## 📊 Monitors Disponíveis

| Categoria | Descrição | Ambientes |
|-----------|-----------|-----------|
| Application | Erros de aplicação, latência, throughput | dev, hom, prod |
| Infrastructure | CPU, Memory, Disk, Network | dev, hom, prod |
| Database | Conexões, queries lentas, replicação | hom, prod |
| Kubernetes | Pods, Deployments, Services | dev, hom, prod |
| AWS | Lambda, ECS, RDS, S3 | hom, prod |
| Custom | Métricas de negócio personalizadas | prod |

## 🚀 Como Usar

### Pré-requisitos
- Terraform >= 1.0
- Datadog API Key e Application Key
- Acesso ao repositório

### Setup Inicial

1. Clone o repositório:
```bash
git clone https://github.com/cleybersilva/datadog-monitors-infra.git
cd datadog-monitors-infra
```

2. Configure as variáveis de ambiente:
```bash
export DD_API_KEY="sua-api-key"
export DD_APP_KEY="sua-app-key"
export TF_VAR_environment="prod"
```

3. Inicialize o Terraform:
```bash
cd infra
terraform init
```

4. Aplique os monitors:
```bash
terraform plan -var-file="../inventories/prod.tfvars"
terraform apply -var-file="../inventories/prod.tfvars"
```

## 📝 Adicionando Novos Monitors

1. Crie o arquivo JSON na pasta `monitors/<ambiente>/`
2. Siga o template padrão (veja `docs/monitor-template.md`)
3. Execute `terraform plan` para validar
4. Abra um Pull Request

## 🔄 CI/CD

O repositório utiliza GitHub Actions para:
- Validar sintaxe dos JSONs de monitors
- Executar `terraform plan` em PRs
- Aplicar automaticamente em merge para main

## 📚 Documentação

- [Catálogo de Monitors](./docs/README.md)
- [Template de Monitor](./docs/monitor-template.md)
- [Guia de Contribuição](./docs/CONTRIBUTING.md)

## 👥 Contribuidores

- Cleyber Silva (@cleybersilva)
- Jarvis (AI Assistant)

---
Gerenciado via Terraform | Datadog Site: us5.datadoghq.com
