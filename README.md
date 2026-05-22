# Agente de E-mails Diários (Daily Email Digest)

## Descrição Geral

Este skill do Hermes Agent automatiza o processo de busca, resumo do conteudo e envio de e-mails não lidos para um número de WhatsApp específico. Ele foi projetado para manter o usuário informado sobre novas comunicações de forma concisa e eficiente.

## Funcionalidades

+--------------------------+     +--------------------------+     +--------------------------+     +--------------------------+
|          Início          | --> | Buscar e-mails não lidos | --> | Processar e-mails        | --> |       Tem e-mails?       |
+--------------------------+     +--------------------------+     +--------------------------+     +--------------------------+
                                                                                                            |
                                                                                                    (Sim)   |
                                                                                                            v
+--------------------------+     +--------------------------+     +--------------------------+
| Gerar Resumo             | --> |  Enviar p/ WhatsApp      | --> |         Fim              |
| (Sub-agente + Prompt)    |     +--------------------------+     +--------------------------+
+--------------------------+     


*   **Busca de E-mails Não Lidos:** Utiliza a ferramenta [Himalaya CLI](https://github.com/hermes-agent/himalaya) para conectar-se a uma conta de e-mail e buscar e-mails não lidos das últimas 24 horas.
*   **Processamento por Script Python:** Os e-mails encontrados são processados por um script Python (`scripts/email_processor.py`) que extrai informações essenciais como remetente, assunto e um trecho do corpo.
*   **Resumo Personalizado:** Um sub-agente utiliza uma instrução externa (`references/email_summary_prompt.md`) para gerar um resumo conciso de cada e-mail. O prompt garante que a saída seja em Português Brasileiro, profissional e adequada para o canal de notificação.
*   **Envio via WhatsApp:** O resumo consolidado dos e-mails é enviado como uma mensagem direta para um número de WhatsApp específico utilizando a ferramenta `send_message`.

## Estrutura do Projeto

*   `SKILL.md`: Define a lógica principal da skill, incluindo os passos de execução, ferramentas utilizadas e interações com sub-agentes.
*   `scripts/email_processor.py`: Script Python responsável por receber a saída bruta do Himalaya, processá-la e preparar os dados para o resumo. Este script também contém a lógica para tratar erros e garantir que apenas a saída JSON limpa seja retornada.
*   `references/`: Diretório contendo arquivos de configuração e prompts externos.
    *   `email_summary_prompt.md`: Prompt detalhado que instrui o sub-agente sobre como resumir e-mails e formatar a mensagem final para o WhatsApp.
    *   `output_handling_fix.md`: Documenta a correção aplicada para garantir que apenas a saída limpa e relevante seja entregue, evitando logs desnecessários do processo.
    *   `user_task_settings.md`: Armazena as preferências do usuário, como idioma, tom de comunicação, conta de e-mail e destino da notificação.