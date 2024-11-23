import json
from db_connection import validate_cpf

def lambda_handler(event, context):
    """
    A function que faz o trabalho de autorizar recurso para API Gateway
    """
    print("Event", json.dumps(event, indent=2))

    cpf = event.get("headers", {}).get("cpf")
    method_arn = event.get("methodArn")
    
    try:
        if validate_token(cpf):
            effect = "Allow"
        else:
            effect = "Deny"

        policy = generate_policy("user", effect, method_arn)
        return policy
    except Exception as e:
        print(f"Error: {e}")
        raise Exception("Unauthorized")

def validate_token(cpf):
    """
    Faz a validação do cpf do cliente
    """
    if not cpf:
        return False
    return validate_cpf(cpf)

def generate_policy(principal_id, effect, resource):
    """
    Gera a policy do IAM para garantir que está autorizado ou não.
    """
    if effect not in ("Allow","Deny"):
        raise ValueError("Invalid policy effect")
    
    policy_document = {
        "Version": "2012-10-17",  # Versão da política
        "Statement": [
            {
                "Action": "execute-api:Invoke",  # Ação permitida/negada
                "Effect": effect,               # Allow ou Deny
                "Resource": resource            # Recurso protegido
            }
        ]
    }
    
    return {
        "principalId": principal_id,  # Identificador único do usuário
        "policyDocument": policy_document,  # Documento da política gerada
        "context": {}
    }