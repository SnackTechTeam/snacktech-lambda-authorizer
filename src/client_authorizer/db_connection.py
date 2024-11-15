import pyodbc

DB_CONFIG = {
    "server": "localhost,1433",
    "database": "SnackTechDb",
    "username": "sa",
    "password": "Senha@12345",
    "driver": "{ODBC Driver 17 for SQL Server}"
}


def validate_cpf(cpf: str):
    """
    Valida se o CPF informado existe na base SQL.
    Configuracoes por enquanto fixas
    """
    connection = None
    try:
        connection = pyodbc.connect(
            f"DRIVER={DB_CONFIG["driver"]}",
            f"SERVER={DB_CONFIG['server']}",
            f"DATABASE={DB_CONFIG['database']}",
            f"UID={DB_CONFIG['username']}",
            f"PWD={DB_CONFIG['password']}",
        )
        cursor = connection.cursor()
        cursor.execute("",(cpf,))
        result = cursor.fetchone()

        return result[0] > 0
    except Exception as e:
        print(f"Database error: {e}")
        return False
    finally:
        if connection:
            connection.close()