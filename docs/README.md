# 📚 Catálogo de Monitors Datadog

## Índice por Categoria

### 🖥️ Infrastructure
| Monitor | Ambiente | Threshold | Prioridade |
|---------|----------|-----------|------------|
| CPU High | prod | >80% | P2 |
| Memory High | prod | <15% available | P2 |
| Disk Space | prod | >80% | P1 |

### 🌐 Application
| Monitor | Ambiente | Threshold | Prioridade |
|---------|----------|-----------|------------|
| Application Errors | prod | >50/5min | P1 |
| RUM JS Errors | prod | >10/5min | P2 |

### ⚡ Performance
| Monitor | Ambiente | Threshold | Prioridade |
|---------|----------|-----------|------------|
| LCP Degradation | prod | >2.5s | P3 |

## Prioridades
- **P1** - Crítico: Impacto em produção, resposta imediata
- **P2** - Alto: Degradação significativa, resposta em 1h
- **P3** - Médio: Monitoramento preventivo, resposta em 4h
- **P4** - Baixo: Informativo, próximo dia útil
