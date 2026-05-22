    bash
    #!/bin/bash
    export HOME="~"
    Adiciona caminhos comuns de binários, incluindo um potencial $HOME/bin
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$HOME/.local/bin:$HOME/bin"

    Verifica se o comando himalaya está disponível
    if ! command -v himalaya &> /dev/null; then
        echo "Erro: Comando 'himalaya' não encontrado no PATH. Por favor, certifique-se de que está instalado e no seu PATH." >&2
        exit 1
    fi

    Verifica se o comando pass está disponível
    if ! command -v pass &> /dev/null; then
        echo "Erro: Comando 'pass' não encontrado no PATH. Por favor, certifique-se de que está instalado e no seu PATH." >&2
        exit 1
    fi

    Tenta obter a senha de aplicativo. Isso também verifica indiretamente a disponibilidade do GPG.
    A mensagem de erro original era "cannot find configuration", não "authentication failed".
    APP_PASSWORD=$(pass show ********** 2>/dev/null)
    if [ -z "$APP_PASSWORD" ]; then
        echo "Aviso: Falha ao obter senha de aplicativo. Pode ser um problema posterior se a autenticação for necessária." >&2
        echo "A configuração do himalaya ainda pode ser acessível apesar deste aviso." >&2
    fi

    echo "Executando: himalaya mail list --since \"24h ago\" --limit 5 --all"

    Executa o comando e captura a saída e o código de saída.
    Usa eval por causa das aspas e '24h ago'.
    OUTPUT=$("himalaya" mail list --since "24h ago" --limit 5 --all 2>&1)
    EXIT_CODE=$?

    if [ $EXIT_CODE -ne 0 ]; then
        echo "Erro ao executar 'himalaya mail list --since \"24h ago\" --limit 5 --all'. Código de saída: $EXIT_CODE" >&2
        echo "Saída do himalaya:" >&2
        echo "$OUTPUT" >&2
        # Se o comando principal falhar, tenta uma verificação de configuração específica como fallback.
        echo "--- Tentando diagnosticar o problema de configuração com 'himalaya account list --debug' ---" >&2
        DIAG_OUTPUT=$("himalaya" account list --debug 2>&1)
        echo "$DIAG_OUTPUT" >&2
        exit 1
    fi

    Se o comando foi bem-sucedido, ecoa a saída para ser processada pelo agente.
    echo "$OUTPUT"

    exit 0