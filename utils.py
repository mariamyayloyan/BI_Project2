import configparser
import pyodbc
import uuid
import os

def get_sql_config(filename, database):
    cf = configparser.ConfigParser()
    cf.read(filename)
    if database not in cf:
        raise ValueError(f"Database configuration '{database}' not found in {filename}")

    _driver = cf.get(database, "DRIVER")
    _server = cf.get(database, "Server")
    _database = cf.get(database, "Database")
    _trusted_connection = cf.get(database, "Trusted_Connection")

    return _driver, _server, _database, _trusted_connection

def connect_db_create_cursor(filename, database_conf_name):
    db_conf = get_sql_config(filename, database_conf_name)
    db_conn_str = 'DRIVER={};Server={};Database={};Trusted_Connection={};'.format(*db_conf)
    db_conn = pyodbc.connect(db_conn_str)
    db_cursor = db_conn.cursor()
    return db_cursor

def load_query(query_name, input_dir):
    sql_script = None
    for script in os.listdir(input_dir):
        if query_name in script:
            with open(os.path.join(input_dir, script), 'r') as script_file:
                sql_script = script_file.read()
            break
    if sql_script is None:
        raise FileNotFoundError(f"No SQL script found for {query_name}")
    return sql_script

def extract_tables_db(cursor, *args):
    results = []
    for x in cursor.execute('exec sp_tables'):
        if x[1] not in args:
            results.append(x[2])
    return results

def extract_table_cols(cursor, table_name):
    result = []
    for row in cursor.columns(table=table_name):
        result.append(row.column_name)
    return result

def find_primary_key(cursor, table_name, schema):
    table_primary_key = cursor.primaryKeys(table_name, schema=schema)
    columns = [column[0] for column in cursor.description]
    results = []
    for row in cursor.fetchall():
        results.append(dict(zip(columns, row)))
    try:
        return results[0]
    except:
        pass
    return results


def read_and_execute_sql_script(connection, filepath):
    with open(filepath, 'r') as file:
        sql_script = file.read()
    cursor = connection.cursor()
    cursor.executescript(sql_script)
    connection.commit()

def execute_insert_script(cursor, table_name, db, schema, df, query):
    insert_script = load_query(f'insert_into_{table_name}', query).format(db=db, schema=schema)
    columns = df.columns.tolist()
    
    for _, row in df.iterrows():
        values = [row[col] for col in columns]
        cursor.execute(insert_script, *values)
        cursor.commit()

def generate_uuid():
    return uuid.uuid4()

def load_sql_file(filepath):
    if os.path.exists(filepath):
        with open(filepath, 'r') as file:
            return file.read()
    else:
        raise FileNotFoundError(f"No such file: '{filepath}'")