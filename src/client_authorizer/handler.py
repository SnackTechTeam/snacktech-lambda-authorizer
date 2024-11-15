import json
from db_connection import validate_cpf

def lambda_handler(event, context):
    """
    A function que faz o trabalho de autorizar recurso para API Gateway
    """
    print("Event", json.dumps(event, indent=2))

    cpf = event.get("cpf")
    method_arn = event.get("methodArn")

    if not cpf or not method_arn:
        raise Exception("Unauthorized")
    
    try:
        if validate_token(cpf):
            policy = generate_policy("user","Allow", method_arn)
        else:
            policy = generate_policy("user", "Deny", method_arn)

        return policy
    except Exception as e:
        print(f"Error: {e}")
        raise Exception("Unauthorized")

def validate_token(cpf):
    """
    Faz a validação do cpf do cliente
    """
    return validate_cpf(cpf)

def generate_policy(principal_id, effect, resource):
    """
    Gera a policy do IAM para garantir que está autorizado ou não.
    """
    if effect not in ("Allow","Deny"):
        raise ValueError("Invalid policy effect")
    
    return {
        "principalId": principal_id,
        "policyDocument":{
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "execute-api:Invoke",
                    "Effect": effect,
                    "Resource": resource,
                }
            ]
        }
    }