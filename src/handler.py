import json
import pyodbc
import os

DB_CONFIG = {
    "server": os.environ['RDS_HOST'],
    "database": os.environ['DB_NAME'],
    "username": os.environ['DB_USER'],
    "password": os.environ['DB_PASSWORD'],
    "driver": "{ODBC Driver 17 for SQL Server}",
    "table": os.getenv("TABLE_NAME","snacktechdb.dbo.Cliente")
}


def lambda_handler(event, context):
    """
    A function que faz o trabalho de autorizar recurso para API Gateway
    """
    print("Event", json.dumps(event))

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

def validate_cpf(cpf: str):
    """
    Valida se o CPF informado existe na base SQL.
    Configuracoes por enquanto fixas
    """
    connection = None
    print(f"pesquisando {cpf}...")
    try:
        connection = pyodbc.connect(
            f"DRIVER={DB_CONFIG['driver']};"
            f"SERVER={DB_CONFIG['server']};"
            f"DATABASE={DB_CONFIG['database']};"
            f"UID={DB_CONFIG['username']};"
            f"PWD={DB_CONFIG['password']};"
        )
        cursor = connection.cursor()
        cursor.execute(f"SELECT ID FROM {DB_CONFIG['table']} WHERE Cpf = ?",(cpf,))
        result = cursor.fetchone()
        print(result)
        return result is not None
    except Exception as e:
        print(f"Database error: {e}")
        return False
    finally:
        if connection:
            connection.close()