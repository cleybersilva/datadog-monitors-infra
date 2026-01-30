# Template de Monitor

Use este template para criar novos monitors:

```json
{
  "name": "[ENV] EMOJI ALERTA: Descrição do Monitor",
  "type": "metric alert | log alert | rum alert | synthetics alert",
  "query": "sua query aqui",
  "message": "## EMOJI Título do Alerta\n\n**Detalhes:**\n- Info 1\n- Info 2\n\n@email-notificacao",
  "tags": ["env:production", "severity:high", "category:infrastructure"],
  "priority": 1,
  "options": {
    "thresholds": {
      "critical": 80,
      "warning": 60
    },
    "notify_no_data": false,
    "renotify_interval": 60
  }
}
```

## Campos Obrigatórios
- `name`: Nome descritivo com ambiente e emoji
- `type`: Tipo do monitor
- `query`: Query do Datadog
- `message`: Mensagem com markdown

## Convenções de Nomenclatura
- Prefixo: `[PROD]`, `[HOM]`, `[DEV]`
- Emoji indicativo do tipo
- Descrição clara do que monitora
