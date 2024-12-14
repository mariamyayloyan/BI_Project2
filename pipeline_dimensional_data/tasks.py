
# import config
# import os
# import pandas as pd
# import pyodbc
# import sys
# import configparser

# parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
# sys.path.append(parent_dir)

# import utils


# def connect_db_create_cursor(database_conf_name):
#     # Call to read the configuration file
#     db_conf = utils.get_sql_config(config.sql_server_config, database_conf_name)
    
#     # Connection string for SQL Server
#     db_conn_str = 'Driver={};Server={};Database={};Trusted_Connection={};'.format(*db_conf)
#     #UID={};PWD={};'.format(*db_conf)

#     #Windows users can try this version and comment the upper line
#     #db_conn_str = 'Driver={};Server={};Database={};Trusted_Connection={};'.format(*db_conf)

#     # Connect to the server and to the desired database
#     db_conn = pyodbc.connect(db_conn_str)
#     # Cursor class instance for executing T-SQL statements
#     db_cursor = db_conn.cursor()
#     return db_cursor
# print(utils.get_sql_config(config.sql_server_config, 'DimensionalDatabase'))

# def load_query(query_name, task_type):
#     input_dir = config.set_input_folder(task_type)  
#     print(input_dir) 
#     for script in os.listdir(input_dir):
#         if query_name in script:
#             with open(input_dir + '/' + script, 'r') as script_file:
#                 sql_script = script_file.read()
#             break
#     return sql_script


# def create_table(cursor):
#     create_table_script = load_query('dimensional_db_table_creation', 'create_table')
#     cursor.execute(create_table_script)
#     cursor.commit()
#     print("The tables have been created in the ORDERS_Dimensional_DB database")
 



# def update_table(cursor, db_rel, schema_rel, table_rel, db_dim, schema_dim, table_dim):
#         update_table_script = load_query(f'update_{table_dim}.sql', 'update')
#         formatted_update_table_script = update_table_script.format(
#         db_dim=db_dim,
#         schema_dim=schema_dim,
#         table_dim=table_dim,
#         db_rel=db_rel,
#         schema_rel=schema_rel,
#         table_rel=table_rel)
        
#         cursor.execute(formatted_update_table_script)
#         cursor.commit()

# create_table(connect_db_create_cursor(['DimensionalDatabase']))

# def update_tables(connect_db_create_cursor, source_db, source_schema, tables, target_db, target_schema):
#     cursor = connect_db_create_cursor()

#     for table in tables:
#         source_table = f"{source_db}.{source_schema}.{table}"
#         target_table = f"{target_db}.{target_schema}.Dim{table}"

#         update_table(cursor, source_table, target_table)
#         print(f"Updated {source_table} to {target_table}")

# tables_list = ['Categories', 'Shippers', 'Territories', 'Customers', 'Region', 'Suppliers', 'Employees', 'Products']
# update_tables(
#     connect_db_create_cursor('db'), 
#     'ORDERS_RELATIONAL_DB', 
#     'dbo', 
#     tables_list, 
#     'ORDERS_DIMENSIONAL_DB', 
#     'dbo'
# )



import sys
import os
import configparser
parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.append(parent_dir)


import utils
#import config

import pandas as pd
import pyodbc

def insert_into_dim_categories(dimensional_cursor, sql_script_dir):
    sql_script = utils.load_query('update_dim_categories', sql_script_dir)
    dimensional_cursor.execute(sql_script)
    dimensional_cursor.commit()
    print("Data has been processed and inserted/updated in the DimCategories table")

def insert_into_dim_customers(dimensional_cursor, sql_script_dir):
    sql_script = utils.load_query('update_dim_customers', sql_script_dir)
    dimensional_cursor.execute(sql_script)
    dimensional_cursor.commit()
    print("Data has been processed and inserted/updated in the DimCustomers table")

def insert_into_dim_employees(dimensional_cursor, sql_script_dir):
    sql_script = utils.load_query('update_dim_employees', sql_script_dir)
    dimensional_cursor.execute(sql_script)
    dimensional_cursor.commit()
    print("Data has been processed and inserted/updated in the DimEmployees table")

def insert_into_dim_products(dimensional_cursor, sql_script_dir):
    sql_script = utils.load_query('update_dim_products', sql_script_dir)
    dimensional_cursor.execute(sql_script)
    dimensional_cursor.commit()
    print("Data has been processed and inserted/updated in the DimProducts table")

def insert_into_dim_region(dimensional_cursor, sql_script_dir):
    sql_script = utils.load_query('update_dim_region', sql_script_dir)
    dimensional_cursor.execute(sql_script)
    dimensional_cursor.commit()
    print("Data has been processed and inserted/updated in the DimRegion table")

def insert_into_dim_shippers(dimensional_cursor, sql_script_dir):
    sql_script = utils.load_query('update_dim_shippers', sql_script_dir)
    dimensional_cursor.execute(sql_script)
    dimensional_cursor.commit()
    print("Data has been processed and inserted/updated in the DimShippers table")

def insert_into_dim_suppliers(dimensional_cursor, sql_script_dir):
    sql_script = utils.load_query('update_dim_supplier', sql_script_dir)
    dimensional_cursor.execute(sql_script)
    dimensional_cursor.commit()
    print("Data has been processed and inserted/updated in the DimSuppliers table")

def insert_into_dim_territories(dimensional_cursor, sql_script_dir):
    sql_script = utils.load_query('update_dim_territories', sql_script_dir)
    dimensional_cursor.execute(sql_script)
    dimensional_cursor.commit()
    print("Data has been processed and inserted/updated in the DimTerritories table")

def insert_into_fact_error(dimensional_cursor, sql_script_dir):
    sql_script = utils.load_query('update_fact_error', sql_script_dir)
    dimensional_cursor.execute(sql_script)
    dimensional_cursor.commit()
    print("Data has been processed and inserted/updated in the Fact Error table")

def insert_into_fact(dimensional_cursor, sql_script_dir):
    sql_script = utils.load_query('update_fact', sql_script_dir)
    dimensional_cursor.execute(sql_script)
    dimensional_cursor.commit()
    print("Data has been processed and inserted/updated in the Fact table")

