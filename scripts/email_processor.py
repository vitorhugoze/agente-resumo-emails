import sys
import json
import re

def process_emails(json_data):
    """
    Processa uma lista de e-mails no formato JSON, extraindo remetente, assunto e um snippet do corpo.
    Retorna uma lista de dicionários com os e-mails processados.
    """
    processed_emails = []
    if not json_data:
        return []

    # Trata possíveis mensagens de erro do Himalaya que impeçam a análise JSON
    if isinstance(json_data, dict) and "error" in json_data:
        return [{"error": json_data.get("error", "Houve um erro desconhecido do Himalaya.")}]
    
    if not isinstance(json_data, list):
        # Se não for uma lista, é um formato de entrada inesperado
        return [{"error": "Formato de entrada inesperado do Himalaya. Esperava uma lista."}]

    for email in json_data:
        sender = email.get('from', 'N/A')
        subject = email.get('subject', 'Sem Assunto')
        body = email.get('body', '')

        snippet = ""
        if body:
            # Remove tags HTML básicas e limpa espaços em branco
            # Para e-mails HTML complexos, uma análise mais robusta seria necessária.
            clean_body = re.sub('<[^<]+?>', ' ', body) 
            snippet = clean_body.strip()
            if len(snippet) > 150:
                snippet = snippet[:150] + "..."
            if not snippet: # Trata casos onde o corpo existe mas fica vazio após limpeza
                snippet = "Sem conteúdo"
        else:
            snippet = "Sem conteúdo"
        
        processed_emails.append({
            "from": sender,
            "subject": subject,
            "snippet": snippet
        })
    return processed_emails

if __name__ == "__main__":
    try:
        # Lê toda a entrada do stdin
        input_data = sys.stdin.read()
        emails = json.loads(input_data)
        
        processed_list = process_emails(emails)
        
        # Imprime a lista processada em JSON para stdout
        # Usa 'ensure_ascii=False' para lidar melhor com caracteres não ASCII
        print(json.dumps(processed_list, indent=2, ensure_ascii=False))
        
    except json.JSONDecodeError:
        # Se a entrada não for JSON válido, imprime um erro no stderr.
        error_msg = "Falha ao analisar a entrada JSON do Himalaya. Verifique se é um JSON válido."
        print(json.dumps([{"error": error_msg}]), file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        error_msg = f"Ocorreu um erro inesperado: {str(e)}"
        print(json.dumps([{"error": error_msg}]), file=sys.stderr)
        sys.exit(1)
