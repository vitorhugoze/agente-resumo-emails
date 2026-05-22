---
name: daily-email-digest
description: |
  Busca e-mails não lidos, os processa com um script auxiliar,
  resumindo-os para envio via WhatsApp, usando um prompt externo.
---
# Skill Definition for Daily Email Digest

steps:
  - name: Buscar e Processar E-mails via Script
    description: Busca e-mails não lidos via Himalaya e os processa para extrair informações relevantes usando um script Python.
    run:
      tool: terminal
      # Comandos para obter a data de ontem (formato GNU date) e executar o himalaya,
      # redirecionando a saída JSON para o script processador.
command: >
  YESTERDAY=$(date -d 'yesterday' +%Y-%m-%d)
  himalaya envelope list -a ***** --output json "not flag Seen and after $YESTERDAY" | python ~/.hermes/skills/email/daily-email-digest/scripts/email_processor.py

  - name: Resumir e Enviar via WhatsApp
    description: Usa um agente subalterno para resumir os e-mails processados e enviar o resumo via WhatsApp, com base em um prompt externo.
    run:
      tool: delegate_task
      # O prompt detalhado é carregado de um arquivo de referência para maior clareza e modularidade.
      goal: file_content:references/email_summary_prompt.md
      context: |
        # A variável 'processed_emails_json' conterá a saída JSON do script email_processor.py.
        # Pode ser uma lista de e-mails processados ou um objeto JSON contendo uma chave "error" ou "empty".
        processed_emails_json: "$step_1_output"
      toolsets: ["terminal", "send_message", "web"] # Ferramentas necessárias para a execução do sub-agente.
